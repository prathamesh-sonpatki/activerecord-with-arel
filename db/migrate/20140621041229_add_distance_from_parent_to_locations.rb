class AddDistanceFromParentToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :distance_from_parent, :integer
  end
end
