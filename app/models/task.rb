class Task < ActiveRecord::Base
  belongs_to :location

  validates :name, presence: true

  # RAW
  def self.order_criteria_raw
    "coalesce('completed_at', 'created_at')"
  end

  # Arel
  def self.order_criteria
    Arel::Nodes::NamedFunction.new('coalesce', ['completed_at', 'created_at'])
  end

  private

  def self.table
    arel_table
  end
end
