class Restaurant < ActiveRecord::Base
  belongs_to :location

  # RAW
  def self.food_search_raw search_term
    where("cuisine ILIKE ? OR cuisine ILIKE ? or cuisine ILIKE ?", '%indian%', '%chinese%', "%#{search_term}%" )
    # SELECT restaurants.* FROM restaurants  WHERE (cuisine ILIKE '%indian%' OR cuisine ILIKE '%chinese%' or cuisine ILIKE '%india%')
  end

  # Arel
  def self.food_search search_term
    where(table[:cuisine].matches_any(['%indian%', '%chinese%', "%#{search_term}%"]))
    # SELECT restaurants.* FROM restaurants  WHERE ((restaurants.cuisine ILIKE '%indian%' OR restaurants.cuisine ILIKE '%chinese%' OR restaurants.cuisine ILIKE '%india%'))
  end

  # Negation Arel
  def self.food_search_not search_term
    where(table[:cuisine].does_not_match(search_term))
    # SELECT restaurants.* FROM restaurants  WHERE (restaurants.cuisine NOT ILIKE 'indian')
  end

  # Range example
  # RAW
  def self.cost_in_range_raw range
    where("cost BETWEEN ? AND ?", range.first, range.last)
    # Restaurant.cost_in_range_raw 12..45
    # SELECT "restaurants".* FROM "restaurants"  WHERE (cost BETWEEN 12 AND 45)
  end

  # Arel
  def self.cost_in range
    where(table[:cost].in range)
    # Restaurant.cost_in([12,45])
    # SELECT restaurants.* FROM restaurants  WHERE restaurants.cost IN (12, 45)
    # Restaurant.cost_in(12..45)
    # SELECT restaurants.* FROM restaurants  WHERE (restaurants.cost BETWEEN 12 AND 45)
  end

  # InsertManager
  def self.insert_restaurant_with_location_and_cuisine(cuisine, location_id)
    manager = Arel::InsertManager.new table.engine
    manager.into table
    manager.insert [[table[:cuisine], 'cuisine'], [table[:location_id], location_id]]
    manager.to_sql
    # INSERT INTO restaurants (cuisine, location_id) VALUES ('cuisine', 1)
  end

  private

  def self.table
    arel_table
  end
end
