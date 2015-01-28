class Match < ActiveRecord::Base
  has_many :match_teams, dependent: :destroy
  has_many :match_players, dependent: :destroy

  has_many :teams, through: :match_teams
  has_many :players, through: :match_players

  OVER = 'over'
  ONGOING = 'ongoing'

  scope :over, -> { where(status: OVER) }
  scope :ongoing, -> { where(status: ONGOING) }
  
  def home_team
    teams.last
  end

  def away_team
    teams.first
  end

  def home_team_statistics
    match_teams.last
  end

  def away_team_statistics
    match_teams.first
  end

  def home_player_statistics
    match_players.joins(:player).where(['players.team_id = ?', home_team.id])
  end

  def away_player_statistics
    match_players.joins(:player).where(['players.team_id = ?', away_team.id])
  end
end
