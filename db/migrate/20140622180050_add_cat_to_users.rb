class AddCatToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cat, :boolean
  end
end
