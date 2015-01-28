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
