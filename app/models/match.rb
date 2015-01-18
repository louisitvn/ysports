class Match < ActiveRecord::Base
  has_many :match_teams
  has_many :teams, through: :match_teams
  has_many :players, through: :match_players
  has_many :match_players

  def home_team
    teams.first
  end

  def away_team
    teams.last
  end

  def home_player_statistics
    match_players.joins(:player).where(['players.team_id = ?', home_team.id])
  end

  def away_player_statistics
    match_players.joins(:player).where(['players.team_id = ?', away_team.id])
  end
end
