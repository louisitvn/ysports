# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create default scraping task
Task.delete_all

Task.create name: 'Yahoo Sports (Over)', status: 'Stopped', progress: '0%', interval: 60*60*12
Task.create name: 'Yahoo Sports (Ongoing)', status: 'Stopped', progress: '0%', interval: 60

# Leagues
League.find_or_create_by name: "atp"              , sport_name: "Tennis"
League.find_or_create_by name: "mlb"              , sport_name: "Baseball"
League.find_or_create_by name: "mls"              , sport_name: "Soccer"
League.find_or_create_by name: "nascar"           , sport_name: "Car Racing"
League.find_or_create_by name: "nba"              , sport_name: "Basketball"
League.find_or_create_by name: "ncaab"            , sport_name: "Basketball"
League.find_or_create_by name: "ncaaf"            , sport_name: "Football"
League.find_or_create_by name: "ncaawb"           , sport_name: "Basketball"
League.find_or_create_by name: "nfl"              , sport_name: "Football"
League.find_or_create_by name: "nhl"              , sport_name: "Hockey"
League.find_or_create_by name: "pga"              , sport_name: "Golf"
League.find_or_create_by name: "boxing"           , sport_name: "Boxing"
League.find_or_create_by name: "premier league"   , sport_name: "Soccer"
League.find_or_create_by name: "summer olympics"  , sport_name: "Olympics"
League.find_or_create_by name: "winter olympics"  , sport_name: "Olympics"
League.find_or_create_by name: "wnba"             , sport_name: "Basketball"
League.find_or_create_by name: "world cup"        , sport_name: "Soccer"
League.find_or_create_by name: "wta"              , sport_name: "Tennis"
League.find_or_create_by name: "bundesliga"       , sport_name: "Soccer"
League.find_or_create_by name: "cfl"              , sport_name: "Football"
League.find_or_create_by name: "champions league" , sport_name: "Soccer"
League.find_or_create_by name: "formula 1"        , sport_name: "Car Racing"
League.find_or_create_by name: "horse racing"     , sport_name: "Horse Racing"
League.find_or_create_by name: "indy car Racing"  , sport_name: "Car Racing"
League.find_or_create_by name: "lpga"             , sport_name: "Golf"
