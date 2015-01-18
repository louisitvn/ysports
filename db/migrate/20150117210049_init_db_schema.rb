class InitDbSchema < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :url
      t.timestamps null: false
    end

    create_table :players do |t|
      t.string :name
      t.string :url
      t.timestamps null: false
    end

    create_table :matches do |t|
      t.string :league
      t.string :season
      t.string :url
      t.datetime :datetime
      t.string :title

      t.timestamps null: false
    end

    create_table :match_players do |t|
      t.timestamps null: false
    end

    create_table :match_teams do |t|
      t.integer :score_1
      t.integer :score_2
      t.integer :score_3
      t.integer :score_4
      t.integer :score_ot
      t.integer :score_total

      t.integer :first_downs
      t.integer :passes_for_first
      t.integer :rushes_for_first
      t.integer :penalties_for_first
      
      t.string  :third_down_efficiency
      
      t.string  :fourth_down_efficiency
      
      t.integer :total_yards
      t.integer :total_plays
      t.integer :avg_gain_per_play

      t.integer :turnovers
      t.string  :time_of_possession

      t.integer :net_yards_rushing
      t.integer :rushes
      t.float   :yards_per_rush

      t.integer :net_yards_passing
      t.integer :comp_att
      t.float   :yards_per_pass
      t.integer :times_sacked
      t.integer :yds_lost_to_sacks
      t.integer :interceptions

      t.integer :punts
      t.integer :punt_average

      t.integer :penalties
      t.integer :penalty_yards

      t.integer :fumbles
      t.integer :fumbles_lost


      t.timestamps null: false
    end

    add_reference :players, :team
    add_reference :match_teams, :team
    add_reference :match_teams, :match
    add_reference :match_players, :player
    add_reference :match_players, :match
  end
end
