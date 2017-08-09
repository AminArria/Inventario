class DataCenter < ApplicationRecord
  has_many :clusters
  has_many :hosts, through: :clusters

  validates :name, presence: true

  def cpu_total
    self.clusters.sum(:cpu_total)
  end

  def cpu_used
    self.clusters.sum(:cpu_used)
  end

  def cpu_free
    self.clusters.sum {|c| c.cpu_free}
  end

  def memory_total
    self.clusters.sum(:memory_total)
  end

  def memory_used
    self.clusters.sum(:memory_used)
  end

  def memory_free
    self.clusters.sum {|c| c.memory_free}
  end
end
