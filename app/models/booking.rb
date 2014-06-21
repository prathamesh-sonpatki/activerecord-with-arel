class Booking < ActiveRecord::Base
  validates :traveler, presence: true
  validates :location, presence: true

  belongs_to :location
  belongs_to :traveler
end
