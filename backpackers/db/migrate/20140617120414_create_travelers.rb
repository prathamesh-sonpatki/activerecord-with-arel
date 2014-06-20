class CreateTravelers < ActiveRecord::Migration
  def change
    create_table :travelers do |t|
      t.string :name
      t.timestamps
    end
  end
end
