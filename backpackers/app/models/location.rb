class Location < ActiveRecord::Base
  has_many :nearby_locations, class_name: 'Location', foreign_key: 'parent_location_id'
  has_many :reviews

  belongs_to :landmark, class_name: 'Location'

  validates :name, presence: true
  validates :location_type, presence: true

  def self.with_reviews_if_available
    # Left outer join
    joins(table.join(Review.table, Arel::OuterJoin).on(table[:id].eq(Review.table[:location_id])).join_sources)
    # Innter join with extra join conditions
    # joins(table.join(Review.table).on(table[:id].eq(Review.table[:location_id].and(Review.rating_more_than_3)).join_sources))
  end

  private

  def self.table
    arel_table
  end
end
