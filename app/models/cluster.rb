class Cluster < ApplicationRecord
  has_many :hosts
  belongs_to :data_center

  validates :name, presence: true
  validates :cpu_total, :cpu_used, :memory_total, :memory_used, :disk_total,
            :disk_used, :physical_cores, :virtual_cores, :hosts_total,
            :hosts_active, numericality: {greater_than_or_equal_to: 0}
  validates :cpu_used, numericality: {less_than_or_equal_to: :cpu_total}
  validates :memory_used, numericality: {less_than_or_equal_to: :memory_total}
  validates :disk_used, numericality: {less_than_or_equal_to: :disk_total}
  validates :hosts_active, numericality: {less_than_or_equal_to: :hosts_total}

  before_validation :nil_to_cero

  def cpu_free
    cpu_total - cpu_used
  end

  def memory_free
    memory_total - memory_used
  end

  def disk_free
    disk_total - disk_used
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

    stats[:cpu_free] = stats[:cpu_total] - stats[:cpu_used]
    stats[:memory_free] = stats[:memory_total] - stats[:memory_used]
    stats[:instances_free] = stats[:instances_total] - stats[:instances_used]
    stats[:used_percent] = stats[:instances_used] / stats[:instances_total].to_f * 100
    stats[:free_percent] = stats[:instances_free] / stats[:instances_total].to_f * 100
    stats
  end

  private

  def nil_to_cero
    cpu_total ||= 0.0
    cpu_used ||= 0.0
    memory_total ||= 0.0
    memory_used ||= 0.0
    disk_total ||= 0.0
    disk_used ||= 0.0
    physical_cores ||= 0
    virtual_cores ||= 0
    hosts_total ||= 0
    hosts_active ||= 0
  end
end
