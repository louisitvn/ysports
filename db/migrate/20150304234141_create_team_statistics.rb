class CreateTeamStatistics < ActiveRecord::Migration
  def change
    create_table :team_statistics do |t|
      t.references :team, index: true
      t.references :match, index: true

      # Team data
      t.integer  "score_1"
      t.integer  "score_2"
      t.integer  "score_3"
      t.integer  "score_4"
      t.integer  "score_ot"
      t.integer  "score_total"
      t.integer  "first_downs"
      t.integer  "passes_for_first"
      t.integer  "rushes_for_first"
      t.integer  "penalties_for_first"
      t.string   "third_down_efficiency"
      t.string   "fourth_down_efficiency"
      t.integer  "total_yards"
      t.integer  "total_plays"
      t.integer  "avg_gain_per_play"
      t.integer  "turnovers"
      t.string   "time_of_possession"
      t.integer  "net_yards_rushing"
      t.integer  "rushes"
      t.float    "yards_per_rush"
      t.integer  "net_yards_passing"
      t.integer  "comp_att"
      t.float    "yards_per_pass"
      t.integer  "times_sacked"
      t.integer  "yds_lost_to_sacks"
      t.integer  "interceptions"
      t.integer  "punts"
      t.integer  "punt_average"
      t.integer  "penalties"
      t.integer  "penalty_yards"
      t.integer  "fumbles"
      t.integer  "fumbles_lost"
      t.float    "shots_on_goal"
      t.float    "1st"
      t.float    "2nd"
      t.float    "3rd"
      t.float    "ot"
      t.float    "power_plays"
      t.float    "converted"
      t.string   "power_play_percentage"
      t.float    "penalty_minutes"
      t.float    "faceoffs_won"
      t.string   "faceoff_percentage"
      t.float    "hits"
      t.float    "blocks"
      t.integer  "score"
      t.float    "possession"
      t.float    "tackle_success"
      t.float    "pass_accuracy"
      t.float    "shots"
      t.float    "corners"
      t.float    "saves"
      t.float    "offsides"
      t.float    "fouls"
      t.float    "yellows"

      t.timestamps null: false
    end
    add_foreign_key :team_statistics, :matches
    add_foreign_key :team_statistics, :teams
  end
end
