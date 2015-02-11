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
      t.string :status, default: 'over'

      t.timestamps null: false
    end

    create_table :match_players do |t|
      t.float :passing_comp
      t.float :passing_att
      t.float :passing_yds
      t.float :passing_pct
      t.float :passing_y_a
      t.float :passing_sack
      t.float :passing_yds_l
      t.float :passing_td
      t.float :passing_int
      t.float :passing_qb_rat
      t.float :passing_fum_l

      t.float :rushing_rush
      t.float :rushing_yds
      t.float :rushing_avg
      t.float :rushing_long
      t.float :rushing_td
      t.float :rushing_fum_l

      t.float :receiving_rec
      t.float :receiving_tgt
      t.float :receiving_yds
      t.float :receiving_avg
      t.float :receiving_long
      t.float :receiving_td
      t.float :receiving_fum_l

      t.float :kicking_xpm
      t.float :kicking_xpa
      t.float :kicking_fgm
      t.float :kicking_fga
      t.float :kicking_long
      t.float :kicking_pct
      t.float :kicking_pts

      t.float :punting_punt
      t.float :punting_avg
      t.float :punting_in20
      t.float :punting_tb

      t.float :returns_kr
      t.float :returns_yds
      t.float :returns_avg
      t.float :returns_long
      t.float :returns_td
      t.float :returns_pr
      t.float :returns_yds
      t.float :returns_avg
      t.float :returns_long
      t.float :returns_td

      t.float :defense_solo
      t.float :defense_ast
      t.float :defense_sack
      t.float :defense_yds_l
      t.float :defense_pd
      t.float :defense_int
      t.float :defense_yds
      t.float :defense_int_td

      t.string :ongoing_min
      t.string :ongoing_fg
      t.string :ongoing_3pt
      t.string :ongoing_ft
      t.string :ongoing_increase_decrease
      t.float :ongoing_off
      t.float :ongoing_def
      t.float :ongoing_reb
      t.float :ongoing_ast
      t.float :ongoing_to
      t.float :ongoing_stl
      t.float :ongoing_blk
      t.float :ongoing_ba
      t.float :ongoing_pf
      t.float :ongoing_pts

      t.float :skaters_g
      t.float :skaters_a
      t.float :skaters_pts
      t.float :skaters_increase
      t.float :skaters_pim
      t.float :skaters_sog
      t.float :skaters_bks
      t.float :skaters_hits
      t.float :skaters_take
      t.float :skaters_give
      t.float :skaters_fw
      t.float :skaters_fl
      t.string :skaters_fo_percentage
      t.string :skaters_shifts
      t.string :skaters_toi

      t.float :goaltending_sa
      t.float :goaltending_ga
      t.float :goaltending_sv
      t.string :goaltending_sv_percentage
      t.string :goaltending_toi

      # soccers
      t.float :goalkeepers_g
      t.float :goalkeepers_sav
      t.float :goalkeepers_gc
      t.float :goalkeepers_gk
      t.float :goalkeepers_fc
      t.float :goalkeepers_fs
      t.float :goalkeepers_y
      t.float :goalkeepers_r
      t.float :goalkeepers_pen
      t.float :goalkeepers_mins
      t.float :defenders_g
      t.float :defenders_ga
      t.float :defenders_sho
      t.float :defenders_ta
      t.float :defenders_clr
      t.float :defenders_cor
      t.float :defenders_fc
      t.float :defenders_fs
      t.float :defenders_y
      t.float :defenders_r
      t.float :defenders_pen
      t.float :defenders_mins
      t.float :defenders_g
      t.float :defenders_ga
      t.float :defenders_sho
      t.float :defenders_ta
      t.float :defenders_clr
      t.float :defenders_cor
      t.float :defenders_fc
      t.float :defenders_fs
      t.float :defenders_y
      t.float :defenders_r
      t.float :defenders_pen
      t.float :defenders_mins
      t.float :forwards_g
      t.float :forwards_ga
      t.float :forwards_sho
      t.float :forwards_pas
      t.float :forwards_fk
      t.float :forwards_cor
      t.float :forwards_fc
      t.float :forwards_fs
      t.float :forwards_y
      t.float :forwards_r
      t.float :forwards_pen
      t.float :forwards_mins

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

      t.float :shots_on_goal
      t.float '1st'
      t.float '2nd'
      t.float '3rd'
      t.float :ot
      t.float :power_plays
      t.float :converted
      t.string :power_play_percentage
      t.float :penalty_minutes
      t.float :faceoffs_won
      t.string :faceoff_percentage
      t.float :hits
      t.float :blocks

      # Soccers
      t.integer :score
      t.float :possession
      t.float :tackle_success
      t.float :pass_accuracy
      t.float :shots
      t.float :shots_on_goal
      t.float :corners
      t.float :saves
      t.float :offsides
      t.float :fouls
      t.float :yellows

      t.timestamps null: false
    end

    add_reference :players, :team
    add_reference :match_teams, :team
    add_reference :match_teams, :match
    add_reference :match_players, :player
    add_reference :match_players, :match
  end
end
