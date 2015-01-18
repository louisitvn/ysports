json.array!(@matches) do |match|
  json.extract! match, :id, :league, :season, :datetime, :title
  json.url match_url(match, format: :json)
end
