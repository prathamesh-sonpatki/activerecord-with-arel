class Location < ActiveRecord::Base
  has_many :nearby_locations, class_name: 'Location', foreign_key: 'parent_location_id'
  has_many :reviews
  has_many :bookings

  belongs_to :landmark, class_name: 'Location'

  validates :name, presence: true
  validates :location_type, presence: true

  def self.with_reviews_if_available
    # Left outer join
    joins(
      table.join(Review.table, Arel::OuterJoin)
           .on(table[:id].eq(Review.table[:location_id])
         ).join_sources
         )
  end

  def self.with_reviews_having_rating_greater_than(rating = 3)
    joins(
      table.join(Review.table, Arel::OuterJoin).
            on(locations_reviews_join.and(Review.having_rating_more_than(rating)))
            .join_sources
         )
  end

  def self.locations_reviews_join
    table[:id].eq(Review.table[:location_id])
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

  private

  def self.table
    arel_table
  end
end
