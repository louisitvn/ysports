class Team < ActiveRecord::Base
  has_many :players, dependent: :destroy
  belongs_to :league

  has_many :home_team_matches, class_name: 'Match'
  has_many :away_team_matches, class_name: 'Match'
end
