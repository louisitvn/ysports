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

ActiveRecord::Schema.define(version: 20150117210049) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "match_players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "player_id"
    t.integer  "match_id"
  end

  create_table "match_teams", force: :cascade do |t|
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
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "team_id"
    t.integer  "match_id"
  end

  create_table "matches", force: :cascade do |t|
    t.string   "league"
    t.string   "season"
    t.string   "url"
    t.datetime "datetime"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
