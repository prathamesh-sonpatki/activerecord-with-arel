class Review < ActiveRecord::Base
  validates :traveler, presence: true
  validates :location, presence: true

  belongs_to :traveler
  belongs_to :location

  # RAW
  def self.having_rating_more_than_raw(rating)
    where("rating > ?", rating)
  end

  # Arel
  def self.having_rating_more_than(rating)
    table[:rating].gt(rating)
  end

  # DONTREF: Find all reviews, first sorted by rating then by created_at, group on location_id
  # "id, row_number() OVER (PARTITION BY category_id ORDER BY price ASC, name ASC)"
  def self.sorted_reviews
    manager = Arel::SelectManager.new table.engine
    manager.from table
    manager.project Arel.star
    manager.group(table[:location_id])

    # window = Arel::Nodes::Window.new.order(table[:rating].desc, table[:created_at].desc)
    # table[:rating].count.over(window)
    manager.window('sorted_reviews').order(table[:rating].desc, table[:created_at].desc)
    manager
    #table.over window
  end

  private

  def self.table
    arel_table
  end
end
