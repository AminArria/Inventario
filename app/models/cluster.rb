class Cluster < ApplicationRecord
  has_many :hosts
  belongs_to :data_center

  validates :name, presence: true
  validates :cpu_total, :cpu_used, :memory_total, :memory_used, numericality: {greater_than_or_equal_to: 0}
  validates :cpu_used, numericality: {less_than_or_equal_to: :cpu_total}
  validates :memory_used, numericality: {less_than_or_equal_to: :memory_total}

  before_validation :nil_to_cero

  def cpu_free
    cpu_total - cpu_used
  end

  def memory_free
    memory_total - memory_used
  end

  def instances_total
    cpu = (cpu_total / ENV["vmware_instance_cpu"].to_i).to_i
    memory = (memory_total / ENV["vmware_instance_memory"].to_i).to_i
    return (cpu <= memory ? cpu : memory)
  end

  def instances_used
    cpu = (cpu_used / ENV["vmware_instance_cpu"].to_i).to_i
    memory = (memory_used / ENV["vmware_instance_memory"].to_i).to_i
    return (cpu <= memory ? cpu : memory)
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
    self.cpu_total ||= 0.0
    self.cpu_used ||= 0.0
    self.memory_total ||= 0.0
    self.memory_used ||= 0.0
  end
end
