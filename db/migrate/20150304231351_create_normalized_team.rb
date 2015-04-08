class CreateNormalizedTeam < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :full_name
      t.string :prefix
      t.string :city
      t.string :url
      t.references :league, index: true

      t.timestamps null: false
    end
    add_foreign_key :teams, :leagues
  end
end
