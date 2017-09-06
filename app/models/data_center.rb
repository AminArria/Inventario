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

  def instances_total
    cpu = (cpu_total / ENV["vmware_instance_cpu"].to_i).to_i
    memory = (memory_total / ENV["vmware_instance_memory"].to_i).to_i
    return (cpu <= memory ? cpu : memory)
  end

  def instances_used
    cpu = (cpu_used / ENV["vmware_instance_cpu"].to_i).to_i
    memory = (memory_used / ENV["vmware_instance_memory"].to_i).to_i
    return (cpu >= memory ? cpu : memory)
  end

  def stats
    stats = {
      cpu_total: cpu_total,
      cpu_used: cpu_used,
      memory_total: memory_total,
      memory_used: memory_used,
      instances_total: instances_total,
      instances_used: instances_used
    }
  end

  def self.global_instance_stats
    stats = {
      instances_total: 0,
      instances_used: 0
    }

    DataCenter.all.each do |dc|
      stats[:instances_total] += dc.instances_total
      stats[:instances_used] += dc.instances_used
    end

    stats[:instances_free] = stats[:instances_total] - stats[:instances_used]
    stats[:used_percent] = stats[:instances_used] / stats[:instances_total].to_f * 100
    stats[:free_percent] = stats[:instances_free] / stats[:instances_total].to_f * 100

    stats
  end
end
