class DataCenter < ApplicationRecord
  has_many :clusters
  has_many :hosts, through: :clusters

  validates :name, presence: true
  validates :disk_total, :disk_used, numericality: { greater_than_or_equal_to: 0 }
  validates :disk_used, numericality: {less_than_or_equal_to: :disk_total}

  before_validation :nil_to_cero

  def cpu_total
    clusters.sum(:cpu_total)
  end

  def cpu_used
    clusters.sum(:cpu_used)
  end

  def cpu_free
    clusters.sum {|c| c.cpu_free}
  end

  def memory_total
    clusters.sum(:memory_total)
  end

  def memory_used
    clusters.sum(:memory_used)
  end

  def memory_free
    clusters.sum {|c| c.memory_free}
  end

  def disk_free
    disk_total - disk_used
  end

  def physical_cores
    clusters.sum(:physical_cores)
  end

  def virtual_cores
    clusters.sum(:virtual_cores)
  end

  def ratio_cores
    virtual_cores.fdiv(physical_cores)
  end

  def instances_from_memory?
    (memory_free / ENV["vmware_instance_memory"].to_f).to_i < (disk_free / ENV["vmware_instance_disk"].to_f).to_i
  end

  def instances_free
    memory_instances = (memory_free / ENV["vmware_instance_memory"].to_f).to_i
    disk_instances = (disk_free / ENV["vmware_instance_disk"].to_f).to_i
    return (memory_instances <= disk_instances ? memory_instances : disk_instances)
  end

  def instances_total
    memory_instances = (memory_total / ENV["vmware_instance_memory"].to_f).to_i
    disk_instances = (disk_total / ENV["vmware_instance_disk"].to_f).to_i
    return (instances_from_memory? ? memory_instances : disk_instances)
  end

  def instances_used
    memory_instances = (memory_used / ENV["vmware_instance_memory"].to_f).to_i
    disk_instances = (disk_used / ENV["vmware_instance_disk"].to_f).to_i
    return (instances_from_memory? ? memory_instances : disk_instances)
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

  def self.stats
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

  private

  def nil_to_cero
    disk_total ||= 0.0
    disk_used ||= 0.0
  end
end
