class Match < ActiveRecord::Base
  has_many :match_teams
  has_many :match_users
end
