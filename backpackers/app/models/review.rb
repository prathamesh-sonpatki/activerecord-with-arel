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

  private

  def self.table
    arel_table
  end
end
