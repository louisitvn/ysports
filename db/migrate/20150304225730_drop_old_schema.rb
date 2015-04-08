class DropOldSchema < ActiveRecord::Migration
  def up
    drop_table :match_players
    drop_table :match_teams
    drop_table :matches
    drop_table :players
    drop_table :teams
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
