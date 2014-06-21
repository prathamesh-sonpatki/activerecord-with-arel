class Restaurant < ActiveRecord::Base
  belongs_to :location

  def self.chinese_or_indian_search(search_term)
    where("cuisine ILIKE ? OR cuisine ILIKE ? or cuisine ILIKE ?", '%indian%', '%chinese%', "%#{search_term}%" )
  end

  def self.search search_term
    where(table[:cuisine].matches_any(['%indian%', '%chinese%', "%#{search_term}%"]))
  end

  def self.search_not search_term
    where(table[:cuisine].does_not_match(search_term))
  end

  def self.cost_in_range_raw range
    where("cost BETWEEN ? AND ?", range.first, range.last)
  end

  def self.cost_in range
    where(table[:cost].in range)
  end

  def self.table
    arel_table
  end
end
