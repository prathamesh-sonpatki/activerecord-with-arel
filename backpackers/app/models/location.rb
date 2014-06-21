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

  private

  def self.table
    arel_table
  end
end
