class AddCompletedAtToTasks < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.boolean :completed, default: false
      t.datetime :completed_at
    end
  end
end
