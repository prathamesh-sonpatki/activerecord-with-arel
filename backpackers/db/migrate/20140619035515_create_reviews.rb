class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string     :comment, limit: 5000
      t.integer    :rating, default: 3
      t.references :traveler, null: false
      t.references :location, null: false
      t.timestamps
    end
  end
end
