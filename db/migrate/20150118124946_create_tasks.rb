class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string  :name
      t.integer  :interval, default: 3600
      t.integer :pid
      t.string  :progress
      t.string  :status
      t.datetime  :last_exec

      t.timestamps null: false
    end
  end
end
