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
