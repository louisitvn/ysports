class CreateNormalizedMatch < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :season
      t.string :url
      t.datetime :datetime
      t.string :title
      t.string :status, default: Match::OVER
      t.integer :home_team_id, index: true
      t.integer :away_team_id, index: true

      t.timestamps null: false
    end
    add_foreign_key :matches, :teams, column: :home_team_id
    add_foreign_key :matches, :teams, column: :away_team_id
  end
end
