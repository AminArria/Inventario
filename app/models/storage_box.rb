class StorageBox < ApplicationRecord
  has_many :aggregates
  has_many :volumes, through: :aggregates

  def space_total
    aggregates.sum {|aggr| aggr.space_total}
  end

  def space_used
    aggregates.sum {|aggr| aggr.space_used}
  end

  def space_free
    space_total - space_used
  end

  def self.nas_stats
    stats = {
      box_count: self.count,
      space_total: self.sum {|sb| sb.space_total},
      space_used: self.sum {|sb| sb.space_used},
      space_free: self.sum {|sb| sb.space_free}
    }

    if stats[:space_total] != 0
      stats[:used_percent] = stats[:space_used] / stats[:space_total] * 100
      stats[:free_percent] = stats[:space_free] / stats[:space_total] * 100
    else
      stats[:used_percent] = 100
      stats[:free_percent] = 100
    end

    stats
  end
end
