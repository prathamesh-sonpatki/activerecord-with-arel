class RenameTypeToLocationType < ActiveRecord::Migration
  def change
    rename_column(:locations, :type, :location_type)
  end
end
