class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.references :traveler, null: false
      t.references :location, null: false
      t.integer :no_of_days
      t.timestamps
    end
  end
end
