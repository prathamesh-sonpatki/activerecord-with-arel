class Review < ActiveRecord::Base
  validates :traveler, presence: true
  validates :location, presence: true

  belongs_to :traveler
  belongs_to :location
end
