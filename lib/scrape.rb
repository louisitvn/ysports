require 'optparse'
require 'rubygems'
require 'active_record'
require 'mechanize'
require 'logger'
require 'zlib'

# Logger
$logger = Logger.new(ENV['LOG'] || '/tmp/scraper.log')

$options = {}
parser = OptionParser.new("", 24) do |opts|
  opts.banner = "\nScraper 1.0\nAuthor: Louis (Skype: louisprm)\n\n"

  opts.on("-t", "--task ID", "Task ID") do |v|
    $options[:task] = v
  end

  opts.on("-i", "--interval SECOND", "Interval in second") do |v|
    $options[:interval] = v
  end

  opts.on_tail('-h', '--help', 'Displays this help') do
		puts opts, "", help
    exit
	end
end

parser.parse!

$options[:interval] ||= 1 * 60 * 60 
$options[:interval] = $options[:interval].to_i

# Establish connection
if ENV['DATABASE_URL']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  ActiveRecord::Base.establish_connection(
    adapter: 'postgresql',
    encoding: 'unicode',
    pool: 5,
    database: 'ysports',
    username: 'postgres',
    password: 'postgres',
    host: 'localhost',
    port: 5432
  )
end

# Core EXT
class String
  def deflate
    Zlib.deflate(self)
  end

  def inflate
    Zlib.inflate(self)
  end

  def fix
    self.encode!('UTF-8', :undef => :replace, :invalid => :replace, :replace => "")
  end
end

# Lib
class NSchedule
  def self.every(seconds)
    raise "No block provided" unless block_given?

    while true
      yield
      done_at = Time.now.to_i
      while Time.now.to_i - done_at < seconds.to_i
        sleep 1
      end
    end
  end  
end

# Model
class League < ActiveRecord::Base
  has_many :teams
end

class Team < ActiveRecord::Base
  has_many :players, dependent: :destroy
  belongs_to :league

  has_many :home_team_matches, class_name: 'Match'
  has_many :away_team_matches, class_name: 'Match'
end

class Player < ActiveRecord::Base
  belongs_to :team
end

class Match < ActiveRecord::Base
  belongs_to :away_team, class_name: 'Team'
  belongs_to :home_team, class_name: 'Team'

  has_many :player_statistics

  has_one :home_team_statistics, class_name: 'TeamStatistic'
  has_one :away_team_statistics, class_name: 'TeamStatistic'

  OVER = 'over'
  ONGOING = 'ongoing'

  scope :over, -> { where(status: OVER) }
  scope :ongoing, -> { where(status: ONGOING) }
end

class PlayerStatistic < ActiveRecord::Base
  belongs_to :player
  belongs_to :match
end

class TeamStatistic < ActiveRecord::Base
  belongs_to :team
  belongs_to :match
end

class Task < ActiveRecord::Base; end

# Task
$task = Task.where(id: $options[:task]).first

# Overwrite the Mechanize class to support proxy switching
Mechanize.class_eval do 
  class ProxyList
    attr_reader :proxies, :current

    class Proxy
      attr_reader :host, :port, :username, :passwd
      attr_reader :error, :hit_count, :failure_count, :alive
      attr_reader :events

      def initialize(host, port, username, passwd)
        @host = host
        @port = port.to_s
        @username = username
        @passwd = passwd
        @hit_count = 0
        @failure_count = 0
        @alive = true
        @current = nil
        @events = {}
      end

      def on(event, block)
        @events[event] = block
      end

      def notify(event, *args)
        @events[event].call(*args)
      end

      def increase_hit_count!
        @hit_count += 1
        notify :hit, self
        $logger.info "Done! #{self} HIT: #{self.hit_count}, FAILURE: #{self.failure_count} "
      end

      def increase_failure_count!
        @failure_count += 1
        notify :failure, self
        $logger.warn "Failed! #{self} HIT[#{self.hit_count}], FAILURE[#{self.failure_count}]"
      end

      def mark_dead!
        @alive = false
        notify :dead, self
        $logger.warn "Mark #{self} as dead"
      end

      def alive?
        @alive
      end

      def to_a
        return [@host, @port, @username, @passwd]
      end

      def to_s
        "[#{self.to_a.reject(&:nil?).join(":")}]"
      end

      def equal?(proxy)
        return false if proxy.nil?
        self.host == proxy.host and self.port == proxy.port
      end

      def valid?
        if @host.nil? or @host !~ /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/
          @error = "Invalid host"
        end

        if @port.nil? or @port !~ /[0-9]+/
          @error = "Invalid port"
        end

        return @error.nil?
      end
    end

    def initialize
      @proxies = []
      @current = nil
    end

    def add(proxy)
      @proxies << proxy
    end
    
    def next_proxy
      @current = @proxies.select{|e| e.alive? && !e.equal?(current) }.sample
      return @current
    end

    def self.load(arg)
      list = self.new
      if arg.is_a?(String)
        lines = IO.read(arg).split(/[\r\n]+/).select{|line| line[/^\s*#/].nil? }.map{|line| line.split(":").map{|e| e.strip} }
      else # Array
        lines = arg
      end
      lines.each do |line|
        host, port, username, passwd = line
        proxy = Proxy.new(host, port, username.blank? ? nil : username, passwd.blank? ? nil : passwd)

        if proxy.valid?
          list.add(proxy)
          $logger.info "Proxy added #{proxy}"
        else
          $logger.warn "Invalid proxy #{proxy}: #{proxy.error}"
        end
      end

      return list
    end
  end

  def try(&block)
    loop do
      begin
        if @list.current.nil?
          $logger.info "Using direct connection"
        else
          $logger.info "Using proxy #{@list.current}"
        end
        r = Timeout.timeout(10) { yield(self) }
        @list.current.increase_hit_count! if @list.current
        next_proxy
        return r
      rescue Net::HTTP::Persistent::Error => ex
        # proxy dead
        @list.current.mark_dead! if @list.current
        next_proxy
      rescue Mechanize::ResponseCodeError => ex
        $logger.info "Not found"
        return nil
      rescue Exception => ex # cần làm rõ do Exception nào mà mark-proxy-as-dead, có thể có tr hợp lỗi do website
        $logger.warn("Error: " + ex.message.split(/[\r\n]+/).first)
        @list.current.increase_failure_count! if @list.current
        next_proxy
      end
    end
  end

  def load_proxies(path)
    @list = ProxyList.load(path)
    next_proxy
  end

  def proxy_list
    @list
  end

  def next_proxy
    proxy = @list.next_proxy
    if proxy.nil?
      self.set_proxy nil, nil
    else
      self.set_proxy(*proxy.to_a)
    end
  end

  def on(event, &block)
    @list.proxies.each do |proxy|
      proxy.on(event, block)
    end
  end
end

class Scrape
  SITE = 'http://sports.yahoo.com/'
  LEAGUES = [
    'nfl', 'mlb', 'nhl', 'nba', 'nhl', 'ncaaf', 'ncaab', 'nascar', 'mma', 'premier-league', 'mls', 'champions-league'
  ]

  def soccer?(league)
    ['premier-league', 'mls', 'champions-league'].include?(league.downcase)
  end

  def initialize
    $logger.info "Scraper started"
    @a = Mechanize.new
    @a.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @a.load_proxies([])
  end

  def start
    LEAGUES.each do |league|
      if soccer?(league)
        scoreboard_url = File.join(SITE, 'soccer', league, 'scoreboard')
      else
        scoreboard_url = File.join(SITE, league.downcase, 'scoreboard')
      end

      run(scoreboard_url, {league: league})
    end
  end

  def run(url, meta)
    $logger.info "Checking league #{url}"
    ps = @a.try do |scr|
      scr.get(url).parser
    end

    meta.merge!(
      season: ps.css('#seasons > option[selected]').first ? ps.css('#seasons > option[selected]').first.text.strip : nil
    )
    
    match_urls = ps.css('tr.game.link:not(.pre):not(.live)').map{|tr| File.join(SITE, tr.attributes['data-url'].value) }
    $logger.info "#{match_urls.count} match url(s) found"
    match_urls.each do |match_url| 
      ActiveRecord::Base.transaction {  get_match(match_url, meta) }
    end

  end

  def get_match(match_url, meta)
    $logger.info "Scraping match: #{match_url}"

    # mark a match as OVER
    if match = Match.ongoing.find_by(url: match_url)
      match.update(status: Match::OVER)
    end

    # It's not necessary to scrape finished matches that were scraped more than two days ago
    if Match.exists?(['url = :url AND updated_at >= :updated_at', url: match_url, updated_at: 2.days.ago])
      $logger.info "Match already exists and was scraped 2 days ago"
      return
    end

    resp = @a.try do |scr|
      scr.get(match_url)
    end

    return if resp.nil?

    ps = resp.parser

    File.open('/tmp/test.html', 'w') {|f| f.write resp.body}

    if soccer?(meta[:league])
      team1_url = File.join(SITE, ps.css('div[class="team-info"] > div.name > a').first.attributes['href'].value)
      team2_url = File.join(SITE, ps.css('div[class="team-info"] > div.name > a').last.attributes['href'].value)
    elsif ps.css('table.linescore > tbody > tr:nth-child(1) > td > a').first
      team1_url = File.join(SITE, ps.css('table.linescore > tbody > tr:nth-child(1) > td > a').first.attributes['href'].value)
      team2_url = File.join(SITE, ps.css('table.linescore > tbody > tr:nth-child(2) > td > a').first.attributes['href'].value)

      tdscore1 = ps.css('.linescore > tbody > tr:nth-child(1) > td')
      tdscore2 = ps.css('.linescore > tbody > tr:nth-child(2) > td')
    else
      team1_url = File.join(SITE, ps.css('div.team.away div.name > a').first.attributes['href'].value)
      team2_url = File.join(SITE, ps.css('div.team.home div.name > a').first.attributes['href'].value)

      tdscore1 = ps.css('.linescore table > tbody > tr:nth-child(1) > td')
      tdscore2 = ps.css('.linescore table > tbody > tr:nth-child(2) > td')
    end
    
    if Team.exists?(url: team1_url)
      team1 = Team.find_by_url(team1_url)
    else
      team1 = scrape_team(team1_url, meta)
    end

    return unless team1

    if Team.exists?(url: team2_url)
      team2 = Team.find_by_url(team2_url)
    else
      team2 = scrape_team(team2_url, meta)
    end

    return unless team2
    
    # match info
    begin
      datetime = Time.parse(ps.css('#mediamodulematchheadergrandslam li.left > ul > li').first.xpath('text()').text.strip).to_s
    rescue Exception => ex
      # datetime = nil
      $logger.info "No datetime value"
    end

    match = Match.create(
      title: "#{team1.full_name} vs. #{team2.full_name}",
      url: match_url,
      status: 'over',
      datetime: datetime,
      season: meta[:season],
      away_team: team1,
      home_team: team2
    )

    team1_stat = TeamStatistic.new(team: team1, match: match)
    team2_stat = TeamStatistic.new(team: team2, match: match)
    
    if soccer?(meta[:league])
      team1_stat.score = ps.css('.boxscore > span.score').first.text.strip
      team1_stat.possession = ps.css('h5[class="sports-hd"]').select{|h| h.text == 'Possession'}.first.next_element.css('> span').first.text.strip.to_f if ps.css('h5[class="sports-hd"]').select{|h| h.text == 'Possession'}.first
      team1_stat.pass_accuracy = ps.css('h5[class="sports-hd"]').select{|h| h.text == 'Pass Accuracy'}.first.next_element.css('> span').first.text.strip.to_f if ps.css('h5[class="sports-hd"]').select{|h| h.text == 'Pass Accuracy'}.first
      team1_stat.tackle_success = ps.css('h5[class="sports-hd"]').select{|h| h.text.downcase == 'tackle success'}.first.next_element.css('> span').first.text.strip.to_f if ps.css('h5[class="sports-hd"]').select{|h| h.text.downcase == 'tackle success'}.first
      team1_stat.shots = ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text == 'Shots'}.first.previous_element.text.strip.to_f if ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text == 'Shots'}.first
      team1_stat.shots_on_goal = ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('On Goal')}.first.previous_element.text.strip.to_f if ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('On Goal')}.first
      team1_stat.corners = ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Corners')}.first.previous_element.text.strip.to_f if ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Corners')}.first
      team1_stat.saves = ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Saves')}.first.previous_element.text.strip.to_f if ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Saves')}.first
      team1_stat.offsides = ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Offside')}.first.previous_element.text.strip.to_f if ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Offside')}.first
      team1_stat.fouls = ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Fouls')}.first.previous_element.text.strip.to_f if ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Fouls')}.first
      team1_stat.yellows = ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Yellows')}.first.previous_element.text.strip.to_f if ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Yellows')}.first
      team1_stat.save!
      
      team2_stat.score = ps.css('.boxscore > span.score').last.text.strip
      team2_stat.possession = ps.css('h5[class="sports-hd"]').select{|h| h.text == 'Possession'}.first.next_element.css('> span').last.text.strip.to_f if ps.css('h5[class="sports-hd"]').select{|h| h.text == 'Possession'}.first
      team2_stat.pass_accuracy = ps.css('h5[class="sports-hd"]').select{|h| h.text == 'Pass Accuracy'}.first.next_element.css('> span').last.text.strip.to_f if ps.css('h5[class="sports-hd"]').select{|h| h.text == 'Pass Accuracy'}.first
      team2_stat.tackle_success = ps.css('h5[class="sports-hd"]').select{|h| h.text.downcase == 'tackle success'}.first.next_element.css('> span').last.text.strip.to_f if ps.css('h5[class="sports-hd"]').select{|h| h.text.downcase == 'tackle success'}.first
      team2_stat.shots = ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text == 'Shots'}.first.next_element.text.strip.to_f if ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text == 'Shots'}.first
      team2_stat.shots_on_goal = ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('On Goal')}.first.next_element.text.strip.to_f if ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('On Goal')}.first
      team2_stat.corners = ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Corners')}.first.next_element.text.strip.to_f if ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Corners')}.first
      team2_stat.saves = ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Saves')}.first.next_element.text.strip.to_f if ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Saves')}.first
      team2_stat.offsides = ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Offside')}.first.next_element.text.strip.to_f if ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Offside')}.first
      team2_stat.fouls = ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Fouls')}.first.next_element.text.strip.to_f if ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Fouls')}.first
      team2_stat.yellows = ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Yellows')}.first.next_element.text.strip.to_f if ps.css('li[class="bar-chart  sports-mod-row-seperator"] span[class="stat-heading sports-hd"]').select{|e| e.text.include?('Yellows')}.first
      team2_stat.save!
      
    else
      team1_stat.attributes = ps.css('#mediasportsmatchteamstats > div > table > tbody > tr').map{|tr|  [tr.css('> th').first.text.strip.underscore.gsub(/\s+/, "_").gsub('%', 'percentage'), tr.css('> td:nth-child(2)').first.text.strip]}.to_h
      team1_stat[:score_1] = tdscore1[1].text.strip if tdscore1[1]
      team1_stat[:score_2] = tdscore1[2].text.strip if tdscore1[2]
      team1_stat[:score_3] = tdscore1[3].text.strip if tdscore1[3]
      team1_stat[:score_4] = tdscore1[4].text.strip if tdscore1[4]
      team1_stat[:score_ot] = tdscore1[5].text.strip if tdscore1[5]
      team1_stat[:score_total] = tdscore1[6].text.strip if tdscore1[6]
      team1_stat.save!

      team2_stat.attributes = ps.css('#mediasportsmatchteamstats > div > table > tbody > tr').map{|tr|  [tr.css('> th').first.text.strip.underscore.gsub(/\s+/, "_").gsub('%', 'percentage'), tr.css('> td:nth-child(3)').first.text.strip]}.to_h
      team2_stat[:score_1] = tdscore2[1].text.strip if tdscore2[1]
      team2_stat[:score_2] = tdscore2[2].text.strip if tdscore2[2]
      team2_stat[:score_3] = tdscore2[3].text.strip if tdscore2[3]
      team2_stat[:score_4] = tdscore2[4].text.strip if tdscore2[4]
      team2_stat[:score_ot] = tdscore2[5].text.strip if tdscore2[5]
      team2_stat[:score_total] = tdscore2[6].text.strip if tdscore2[6]
      team2_stat.save!
    end
    
    # player statistics
    if soccer?(meta[:league])
      groups = ['Goalkeepers', 'Defenders', 'Defenders', 'Forwards']
      groups.each do |group|
        headers1 = ps.css('div.full:nth-child(1) > h5').select{|x| x.text.include?(group)}.first.next_element.css('table > thead > tr > th')[1..-1].map{|e| "#{group}_#{e.text.strip}".downcase }
        rows1 = ps.css('div.full:nth-child(1) > h5').select{|x| x.text.include?(group)}.first.next_element.css('table > tbody > tr')
        process_players(headers1, rows1, match, team1)

        headers2 = ps.css('div.full:nth-child(2) > h5').select{|x| x.text.include?(group)}.first.next_element.css('table > thead > tr > th')[1..-1].map{|e| "#{group}_#{e.text.strip}".downcase }
        rows2 = ps.css('div.full:nth-child(2) > h5').select{|x| x.text.include?(group)}.first.next_element.css('table > tbody > tr')
        process_players(headers2, rows2, match, team2)
      end
    elsif ps.css('#mediasportsmatchstatsbyplayer h3').select{|h3| h3.text.include?('Goaltending')}.first or ps.css('#mediasportsmatchstatsbyplayer h3').select{|h3| h3.text.include?('Passing')}.first
      if ps.css('#mediasportsmatchstatsbyplayer h3').select{|h3| h3.text.include?('Goaltending')}.first
        groups = ['Goaltending', 'Skaters']
      else
        groups = ['Passing', 'Rushing', 'Receiving', 'Kicking', 'Punting', 'Returns', 'Defense']
      end
      
      groups.each do |group|
        ### Away
        passing_headers1 = ps.css('#mediasportsmatchstatsbyplayer h3').select{|h3| h3.text.include?(group)}.first.parent.parent.css('h4')[0].next_element.css('table > thead > tr > th' ).map{|e| e.text.strip.gsub('+/-', 'increase').gsub('%', '_percentage')}.map{|e| "#{group.downcase}_" + e.underscore.gsub(/[\s\/]+/, "_")}[1..-1]
        passing_rows1 = ps.css('#mediasportsmatchstatsbyplayer h3').select{|h3| h3.text.include?(group)}.first.parent.parent.css('h4')[0].next_element.css('table > tbody > tr' )
        process_players(passing_headers1, passing_rows1, match, team1)

        ### Home
        passing_headers2 = ps.css('#mediasportsmatchstatsbyplayer h3').select{|h3| h3.text.include?(group)}.first.parent.parent.css('h4')[1].next_element.css('table > thead > tr > th' ).map{|e| e.text.strip.gsub('+/-', 'increase').gsub('%', '_percentage')}.map{|e| "#{group.downcase}_" + e.underscore.gsub(/[\s\/]+/, "_")}[1..-1]
        passing_rows2 = ps.css('#mediasportsmatchstatsbyplayer h3').select{|h3| h3.text.include?(group)}.first.parent.parent.css('h4')[1].next_element.css('table > tbody > tr' )
        process_players(passing_headers2, passing_rows2, match, team2)
      end
    else
      away_headers = ps.css('div.data-container')[0].css('> table > thead > tr > th').map{|e| e.text.strip.downcase}.map{|e| (e.include?('+/-')) ? 'increase_decrease' : e }.uniq[1..-1].map{|e| "ongoing_#{e}"}
      away_rows = ps.css('div.data-container')[0].css('> table > tbody > tr')
      process_players(away_headers, away_rows, match, team1)

      home_headers = ps.css('div.data-container')[1].css('> table > thead > tr > th').map{|e| e.text.strip.downcase}.map{|e| (e.include?('+/-')) ? 'increase_decrease' : e }.uniq[1..-1].map{|e| "ongoing_#{e}"}
      home_rows = ps.css('div.data-container')[1].css('> table > tbody > tr')
      process_players(home_headers, home_rows, match, team2)
    end
  end

  def process_players(headers, rows, match, team)
    rows.each do |row|
      next unless row.css('th > a').first
      player_url = File.join(SITE, row.css('th > a').first.attributes['href'].value)

      if Player.exists?(url: player_url)
        player = Player.find_by_url(player_url)
      else
        player = scrape_player(player_url, team)
      end

      return if player.nil?

      player_stat = PlayerStatistic.find_or_initialize_by(match_id: match.id, player_id: player.id)
      
      # extract attributes
      attrs = {}
      values = row.css('td').map{|e| e.text.strip}
      headers.zip(values) { |a,b| attrs[a.to_sym] = b }
      
      # update
      player_stat.attributes = attrs
      player_stat.save!
      $logger.info 'Player statistics saved!'
      $logger.info player_stat.attributes
    end
  end

  def scrape_player(player_url, team)
    $logger.info "Scraping player: #{player_url}"
    if Player.exists?(url: player_url)
      $logger.info "Player already exists"
      return Player.find_by_url(url: player_url)
    end
    
    ps = nil

    3.times do |i|
      ps = @a.try do |scr|
        scr.get(player_url).parser
      end

      return if ps.nil?

      if ps.css('div.player-info h1').first
        break
      else
        sleep 5
      end
    end

    return if ps.nil?

    player = Player.new
    player.url = player_url
    player.name = ps.css('div.player-info h1').first.attributes['data-name'].value
    player.team = team
    player.save
    $logger.info "Player created: [#{player.name}]"

    return player
  end


  def scrape_team(team_url, meta)
    $logger.info "Scraping team: #{team_url}"
    if Team.exists?(url: team_url)
      $logger.info "Team already exists"
      return
    end

    ps = nil

    3.times do |i|
      ps = @a.try do |scr|
        scr.get(team_url).parser
      end

      return if ps.nil?

      if ps.css('div.team-info > h1').first
        break
      else
        sleep 5
      end
    end

    return if ps.nil?

    team = Team.new
    team.league = League.find_or_create_by(name: meta[:league])
    team.url = team_url
    team.full_name = ps.css('div.team-info > h1').first.text.strip
    team.save!
    $logger.info "Team [#{team.full_name}] created"
    return team
  end
end


# trap Ctrl-C
trap("SIGINT") { throw :ctrl_c }

catch :ctrl_c do
  while true
    begin
      NSchedule.every($options[:interval].to_i) do
        $logger.info("Start at #{Time.now.to_s}")
        e = Scrape.new
        e.start
        #e.run('http://sports.yahoo.com/soccer/champions-league/scoreboard/', {league: 'premier-league'})
        $logger.info("Finish at #{Time.now.to_s}")
        $task.update_attributes(last_exec: Time.now) if $task
      end
    rescue Exception => ex
      $logger.info "#{ex.message}\r\nBacktrace:\r\n" + ex.backtrace.join("\r\n")
      $task.update_attributes(progress: "#{ex.message}\r\nBacktrace:\r\n" + ex.backtrace.join("\r\n")) if $task
      sleep 60
    end
  end
end
