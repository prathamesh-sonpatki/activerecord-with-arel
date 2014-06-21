class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name

      t.references :location
      t.references :traveler, null: false
      t.timestamps
    end
  end
end
