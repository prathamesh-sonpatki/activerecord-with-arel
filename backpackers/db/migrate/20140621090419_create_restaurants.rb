class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :cuisine
      t.references :location, index: true
      t.decimal :cost, default: 10

      t.timestamps
    end
  end
end
