class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|

      t.string :name, null: false
      t.string :area
      t.string :type

      t.integer :parent_location_id
      t.timestamps
    end
  end
end
