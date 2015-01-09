class Location < ActiveRecord::Base
  has_many :nearby_locations, class_name: 'Location', foreign_key: 'parent_location_id'
  has_many :reviews
  has_many :bookings

  belongs_to :landmark, class_name: 'Location'

  validates :name, presence: true
  validates :location_type, presence: true

  # Left outer join
  # RAW
  def self.with_reviews_if_available_raw
    joins("LEFT OUTER JOIN reviews ON locations.id = reviews.location_id")
    # SELECT "locations".* FROM "locations" LEFT OUTER JOIN reviews ON locations.id = reviews.location_id
  end

  # Arel
  def self.with_reviews_if_available
    joins(
      table.join(Review.table, Arel::OuterJoin)
           .on(table[:id].eq(Review.table[:location_id])
         ).join_sources
         )
    # SELECT locations.* FROM locations LEFT OUTER JOIN reviews ON locations.id = reviews.location_id
  end

  # Left outer join with extra join condition
  # RAW
  def self.with_reviews_having_rating_greater_than_raw(rating = 3)
    joins("LEFT OUTER JOIN reviews ON locations.id = reviews.location_id AND reviews.rating > #{rating}")
    # SELECT locations.* FROM locations LEFT OUTER JOIN reviews ON locations.id = reviews.location_id AND reviews.rating > 3
  end

  # Arel
  def self.with_reviews_having_rating_greater_than(rating = 3)
    joins(
      table.join(Review.table, Arel::OuterJoin).
            on(locations_reviews_join.and(Review.having_rating_more_than(rating)))
            .join_sources
         )
    # SELECT locations.* FROM locations LEFT OUTER JOIN reviews ON locations.id = reviews.location_id AND reviews.rating > 3
  end

  # All locations for which there has been booking and review with rating more than 3
  # RAW
  def self.all_locations_with_review_and_bookings_raw
    [
      Location.joins("INNER JOIN reviews ON locations.id = reviews.location_id AND reviews.rating > 3"),
      Location.joins(:bookings)
    ].map(&:to_sql).join(" INTERSECT ")
    # SELECT * FROM locations INNER JOIN reviews ON locations.id = reviews.location_id AND reviews.rating > 3
    # INTERSECT
    # SELECT locations.* FROM locations INNER JOIN bookings ON bookings.location_id = locations.id
  end

  # Arel
  def self.all_locations_with_review_and_bookings
    table.join(Review.table)
         .on(locations_reviews_join.and(Review.having_rating_more_than(3)))
         .project(Arel.star)
         .intersect(Location.joins(:bookings))

    # SELECT * FROM locations INNER JOIN reviews ON locations.id = reviews.location_id AND reviews.rating > 3
    # INTERSECT
    # SELECT locations.* FROM locations INNER JOIN bookings ON bookings.location_id = locations.id
  end

  # Self join(In this case AR example is more easier than Arel)
  # RAW
  def self.all_nearby_locations_of_a_type_raw
    joins(:nearby_locations)
    # SELECT locations.* FROM locations INNER JOIN locations nearby_locations_locations ON nearby_locations_locations.parent_location_id = locations.id
  end

  # Arel
  def self.all_nearby_locations_of_a_type
    nearby_locations = table.alias
    joins(table.join(nearby_locations).on(table[:id].eq(nearby_locations[:parent_location_id])).join_sources)
    # SELECT locations.* FROM locations INNER JOIN locations locations_2 ON locations.id = locations_2.parent_location_id
  end

  # All nearby locations within 5 km from parent
  # RAW
  def self.all_nearby_locations_within_distance_from_parent_raw
    joins("INNER JOIN locations nearby_locations
           ON locations.id = nearby_locations.parent_location_id
           AND nearby_locations.distance_from_parent <= #{5}"
    )
    # SELECT "locations".* FROM "locations" INNER JOIN locations nearby_locations
    # ON locations.id = nearby_locations.parent_location_id
    # AND nearby_locations.distance_from_parent <= 5
  end

  # Arel
  def self.all_nearby_locations_within_distance_from_parent
    nearby_locations = table.alias("nearby_locations")
    joins(table.join(nearby_locations)
      .on(table[:id].eq(nearby_locations[:parent_location_id])
                    .and(nearby_locations[:distance_from_parent].lteq(5)
                    # .or(nearby_locations[:location_type].eq('hotel'))
                    # .and(nearby_locations[:location_type].eq('hotel'))
                    )
         )
      .join_sources
    )
    # SELECT locations.* FROM locations INNER JOIN locations nearby_locations
    # ON locations.id = nearby_locations.parent_location_id
    # AND nearby_locations.distance_from_parent <= 5
  end
  private

  def self.table
    arel_table
  end

  def self.locations_reviews_join
    table[:id].eq(Review.table[:location_id])
  end
end
