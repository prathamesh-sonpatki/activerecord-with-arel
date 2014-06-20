class Task < ActiveRecord::Base
  belongs_to :location

  validates :name, presence: true

  def self.order_criteria
    Arel::Nodes::NamedFunction.new('coalesce', ['completed_at', 'created_at'])
  end

  private

  def self.table
    arel_table
  end
end
