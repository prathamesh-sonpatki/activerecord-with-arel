class Review < ActiveRecord::Base
  validates :traveler, presence: true
  validates :location, presence: true

  belongs_to :traveler
  belongs_to :location

  def self.rating_more_than_3
    table[:rating].gt(3)
  end

  private

  def self.table
    arel_table
  end
end
