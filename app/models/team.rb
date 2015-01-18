class Team < ActiveRecord::Base
  has_many :match_teams
  has_many :players
end
