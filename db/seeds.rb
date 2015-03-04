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
League.find_or_create_by name: "ATP"              , sport_name: "Tennis"
League.find_or_create_by name: "MLB"              , sport_name: "Baseball"
League.find_or_create_by name: "MLS"              , sport_name: "Soccer"
League.find_or_create_by name: "NASCAR"           , sport_name: "Car Racing"
League.find_or_create_by name: "NBA"              , sport_name: "Basketball"
League.find_or_create_by name: "NCAAB"            , sport_name: "Basketball"
League.find_or_create_by name: "NCAAF"            , sport_name: "Football"
League.find_or_create_by name: "NCAAWB"           , sport_name: "Basketball"
League.find_or_create_by name: "NFL"              , sport_name: "Football"
League.find_or_create_by name: "NHL"              , sport_name: "Hockey"
League.find_or_create_by name: "PGA"              , sport_name: "Golf"
League.find_or_create_by name: "Boxing"           , sport_name: "Boxing"
League.find_or_create_by name: "Premier League"   , sport_name: "Soccer"
League.find_or_create_by name: "Summer Olympics"  , sport_name: "Olympics"
League.find_or_create_by name: "Winter Olympics"  , sport_name: "Olympics"
League.find_or_create_by name: "WNBA"             , sport_name: "Basketball"
League.find_or_create_by name: "World Cup"        , sport_name: "Soccer"
League.find_or_create_by name: "WTA"              , sport_name: "Tennis"
League.find_or_create_by name: "Bundesliga"       , sport_name: "Soccer"
League.find_or_create_by name: "CFL"              , sport_name: "Football"
League.find_or_create_by name: "Champions League" , sport_name: "Soccer"
League.find_or_create_by name: "Formula 1"        , sport_name: "Car Racing"
League.find_or_create_by name: "Horse Racing"     , sport_name: "Horse Racing"
League.find_or_create_by name: "Indy Car Racing"  , sport_name: "Car Racing"
League.find_or_create_by name: "LPGA"             , sport_name: "Golf"
