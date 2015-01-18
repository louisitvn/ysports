class Player < ActiveRecord::Base
  belongs_to :team
  has_many :match_players, dependent: :destroy
end
