class Traveler < ActiveRecord::Base
  has_many :reviews
  has_many :bookings

  validates :name, presence: true
end
