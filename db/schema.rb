# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150304234141) do

  create_table "leagues", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "sport_name", limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "matches", force: :cascade do |t|
    t.string   "season",       limit: 255
    t.string   "url",          limit: 255
    t.datetime "datetime"
    t.string   "title",        limit: 255
    t.string   "status",       limit: 255, default: "over"
    t.integer  "home_team_id", limit: 4
    t.integer  "away_team_id", limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "matches", ["away_team_id"], name: "index_matches_on_away_team_id", using: :btree
  add_index "matches", ["home_team_id"], name: "index_matches_on_home_team_id", using: :btree

  create_table "player_statistics", force: :cascade do |t|
    t.integer  "player_id",                 limit: 4
    t.integer  "match_id",                  limit: 4
    t.float    "passing_comp",              limit: 24
    t.float    "passing_att",               limit: 24
    t.float    "passing_yds",               limit: 24
    t.float    "passing_pct",               limit: 24
    t.float    "passing_y_a",               limit: 24
    t.float    "passing_sack",              limit: 24
    t.float    "passing_yds_l",             limit: 24
    t.float    "passing_td",                limit: 24
    t.float    "passing_int",               limit: 24
    t.float    "passing_qb_rat",            limit: 24
    t.float    "passing_fum_l",             limit: 24
    t.float    "rushing_rush",              limit: 24
    t.float    "rushing_yds",               limit: 24
    t.float    "rushing_avg",               limit: 24
    t.float    "rushing_long",              limit: 24
    t.float    "rushing_td",                limit: 24
    t.float    "rushing_fum_l",             limit: 24
    t.float    "receiving_rec",             limit: 24
    t.float    "receiving_tgt",             limit: 24
    t.float    "receiving_yds",             limit: 24
    t.float    "receiving_avg",             limit: 24
    t.float    "receiving_long",            limit: 24
    t.float    "receiving_td",              limit: 24
    t.float    "receiving_fum_l",           limit: 24
    t.float    "kicking_xpm",               limit: 24
    t.float    "kicking_xpa",               limit: 24
    t.float    "kicking_fgm",               limit: 24
    t.float    "kicking_fga",               limit: 24
    t.float    "kicking_long",              limit: 24
    t.float    "kicking_pct",               limit: 24
    t.float    "kicking_pts",               limit: 24
    t.float    "punting_punt",              limit: 24
    t.float    "punting_avg",               limit: 24
    t.float    "punting_in20",              limit: 24
    t.float    "punting_tb",                limit: 24
    t.float    "returns_kr",                limit: 24
    t.float    "returns_yds",               limit: 24
    t.float    "returns_avg",               limit: 24
    t.float    "returns_long",              limit: 24
    t.float    "returns_td",                limit: 24
    t.float    "returns_pr",                limit: 24
    t.float    "defense_solo",              limit: 24
    t.float    "defense_ast",               limit: 24
    t.float    "defense_sack",              limit: 24
    t.float    "defense_yds_l",             limit: 24
    t.float    "defense_pd",                limit: 24
    t.float    "defense_int",               limit: 24
    t.float    "defense_yds",               limit: 24
    t.float    "defense_int_td",            limit: 24
    t.string   "ongoing_min",               limit: 255
    t.string   "ongoing_fg",                limit: 255
    t.string   "ongoing_3pt",               limit: 255
    t.string   "ongoing_ft",                limit: 255
    t.string   "ongoing_increase_decrease", limit: 255
    t.float    "ongoing_off",               limit: 24
    t.float    "ongoing_def",               limit: 24
    t.float    "ongoing_reb",               limit: 24
    t.float    "ongoing_ast",               limit: 24
    t.float    "ongoing_to",                limit: 24
    t.float    "ongoing_stl",               limit: 24
    t.float    "ongoing_blk",               limit: 24
    t.float    "ongoing_ba",                limit: 24
    t.float    "ongoing_pf",                limit: 24
    t.float    "ongoing_pts",               limit: 24
    t.float    "skaters_g",                 limit: 24
    t.float    "skaters_a",                 limit: 24
    t.float    "skaters_pts",               limit: 24
    t.float    "skaters_increase",          limit: 24
    t.float    "skaters_pim",               limit: 24
    t.float    "skaters_sog",               limit: 24
    t.float    "skaters_bks",               limit: 24
    t.float    "skaters_hits",              limit: 24
    t.float    "skaters_take",              limit: 24
    t.float    "skaters_give",              limit: 24
    t.float    "skaters_fw",                limit: 24
    t.float    "skaters_fl",                limit: 24
    t.string   "skaters_fo_percentage",     limit: 255
    t.string   "skaters_shifts",            limit: 255
    t.string   "skaters_toi",               limit: 255
    t.float    "goaltending_sa",            limit: 24
    t.float    "goaltending_ga",            limit: 24
    t.float    "goaltending_sv",            limit: 24
    t.string   "goaltending_sv_percentage", limit: 255
    t.string   "goaltending_toi",           limit: 255
    t.float    "goalkeepers_g",             limit: 24
    t.float    "goalkeepers_sav",           limit: 24
    t.float    "goalkeepers_gc",            limit: 24
    t.float    "goalkeepers_gk",            limit: 24
    t.float    "goalkeepers_fc",            limit: 24
    t.float    "goalkeepers_fs",            limit: 24
    t.float    "goalkeepers_y",             limit: 24
    t.float    "goalkeepers_r",             limit: 24
    t.float    "goalkeepers_pen",           limit: 24
    t.float    "goalkeepers_mins",          limit: 24
    t.float    "defenders_g",               limit: 24
    t.float    "defenders_ga",              limit: 24
    t.float    "defenders_sho",             limit: 24
    t.float    "defenders_ta",              limit: 24
    t.float    "defenders_clr",             limit: 24
    t.float    "defenders_cor",             limit: 24
    t.float    "defenders_fc",              limit: 24
    t.float    "defenders_fs",              limit: 24
    t.float    "defenders_y",               limit: 24
    t.float    "defenders_r",               limit: 24
    t.float    "defenders_pen",             limit: 24
    t.float    "defenders_mins",            limit: 24
    t.float    "forwards_g",                limit: 24
    t.float    "forwards_ga",               limit: 24
    t.float    "forwards_sho",              limit: 24
    t.float    "forwards_pas",              limit: 24
    t.float    "forwards_fk",               limit: 24
    t.float    "forwards_cor",              limit: 24
    t.float    "forwards_fc",               limit: 24
    t.float    "forwards_fs",               limit: 24
    t.float    "forwards_y",                limit: 24
    t.float    "forwards_r",                limit: 24
    t.float    "forwards_pen",              limit: 24
    t.float    "forwards_mins",             limit: 24
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "player_statistics", ["match_id"], name: "index_player_statistics_on_match_id", using: :btree
  add_index "player_statistics", ["player_id"], name: "index_player_statistics_on_player_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "url",        limit: 255
    t.integer  "team_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "players", ["team_id"], name: "index_players_on_team_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "interval",   limit: 4,   default: 3600
    t.integer  "pid",        limit: 4
    t.string   "progress",   limit: 255
    t.string   "status",     limit: 255
    t.datetime "last_exec"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "team_statistics", force: :cascade do |t|
    t.integer  "team_id",                limit: 4
    t.integer  "match_id",               limit: 4
    t.integer  "score_1",                limit: 4
    t.integer  "score_2",                limit: 4
    t.integer  "score_3",                limit: 4
    t.integer  "score_4",                limit: 4
    t.integer  "score_ot",               limit: 4
    t.integer  "score_total",            limit: 4
    t.integer  "first_downs",            limit: 4
    t.integer  "passes_for_first",       limit: 4
    t.integer  "rushes_for_first",       limit: 4
    t.integer  "penalties_for_first",    limit: 4
    t.string   "third_down_efficiency",  limit: 255
    t.string   "fourth_down_efficiency", limit: 255
    t.integer  "total_yards",            limit: 4
    t.integer  "total_plays",            limit: 4
    t.integer  "avg_gain_per_play",      limit: 4
    t.integer  "turnovers",              limit: 4
    t.string   "time_of_possession",     limit: 255
    t.integer  "net_yards_rushing",      limit: 4
    t.integer  "rushes",                 limit: 4
    t.float    "yards_per_rush",         limit: 24
    t.integer  "net_yards_passing",      limit: 4
    t.integer  "comp_att",               limit: 4
    t.float    "yards_per_pass",         limit: 24
    t.integer  "times_sacked",           limit: 4
    t.integer  "yds_lost_to_sacks",      limit: 4
    t.integer  "interceptions",          limit: 4
    t.integer  "punts",                  limit: 4
    t.integer  "punt_average",           limit: 4
    t.integer  "penalties",              limit: 4
    t.integer  "penalty_yards",          limit: 4
    t.integer  "fumbles",                limit: 4
    t.integer  "fumbles_lost",           limit: 4
    t.float    "shots_on_goal",          limit: 24
    t.float    "1st",                    limit: 24
    t.float    "2nd",                    limit: 24
    t.float    "3rd",                    limit: 24
    t.float    "ot",                     limit: 24
    t.float    "power_plays",            limit: 24
    t.float    "converted",              limit: 24
    t.string   "power_play_percentage",  limit: 255
    t.float    "penalty_minutes",        limit: 24
    t.float    "faceoffs_won",           limit: 24
    t.string   "faceoff_percentage",     limit: 255
    t.float    "hits",                   limit: 24
    t.float    "blocks",                 limit: 24
    t.integer  "score",                  limit: 4
    t.float    "possession",             limit: 24
    t.float    "tackle_success",         limit: 24
    t.float    "pass_accuracy",          limit: 24
    t.float    "shots",                  limit: 24
    t.float    "corners",                limit: 24
    t.float    "saves",                  limit: 24
    t.float    "offsides",               limit: 24
    t.float    "fouls",                  limit: 24
    t.float    "yellows",                limit: 24
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "team_statistics", ["match_id"], name: "index_team_statistics_on_match_id", using: :btree
  add_index "team_statistics", ["team_id"], name: "index_team_statistics_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "full_name",  limit: 255
    t.string   "prefix",     limit: 255
    t.string   "city",       limit: 255
    t.string   "url",        limit: 255
    t.integer  "league_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "teams", ["league_id"], name: "index_teams_on_league_id", using: :btree

  add_foreign_key "matches", "teams", column: "away_team_id"
  add_foreign_key "matches", "teams", column: "home_team_id"
  add_foreign_key "player_statistics", "matches"
  add_foreign_key "player_statistics", "players"
  add_foreign_key "players", "teams"
  add_foreign_key "team_statistics", "matches"
  add_foreign_key "team_statistics", "teams"
  add_foreign_key "teams", "leagues"
end
