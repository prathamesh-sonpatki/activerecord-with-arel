class Task < ActiveRecord::Base
  belongs_to :location

  validates :name, presence: true
end
