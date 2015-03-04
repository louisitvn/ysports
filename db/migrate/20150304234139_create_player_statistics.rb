class CreatePlayerStatistics < ActiveRecord::Migration
  def change
    create_table :player_statistics do |t|
      t.references :player, index: true
      t.references :match, index: true

      t.timestamps null: false
    end
    add_foreign_key :player_statistics, :matches
    add_foreign_key :player_statistics, :players
  end
end
