class CreateTeamStatistics < ActiveRecord::Migration
  def change
    create_table :team_statistics do |t|
      t.references :team, index: true
      t.references :match, index: true

      t.timestamps null: false
    end
    add_foreign_key :team_statistics, :matches
    add_foreign_key :team_statistics, :teams
  end
end
