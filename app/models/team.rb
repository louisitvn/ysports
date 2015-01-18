class Team < ActiveRecord::Base
  has_many :match_teams, dependent: :destroy
  has_many :players, dependent: :destroy
end
