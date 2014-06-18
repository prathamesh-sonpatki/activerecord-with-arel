class Location < ActiveRecord::Base
  has_many :nearby_locations, class_name: 'Location', foreign_key: 'parent_location_id'

  belongs_to :landmark, class_name: 'Location'

  validates :name, presence: true
  validates :location_type, presence: true
  private

  def self.table
    arel_table
  end
end
