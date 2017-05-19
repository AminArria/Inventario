class Subnet < ApplicationRecord
  belongs_to :section
  has_many :addresses

  validates :api_id, :base, :mask, presence: true
  validates :max_hosts, :used_hosts, numericality: {greater_than_or_equal_to: 0}
  validates_numericality_of :used_hosts, less_than_or_equal_to: :max_hosts

  def free_hosts
    self.max_hosts - self.used_hosts
  end

  def used_percentage
    self.used_hosts / self.max_hosts * 100
  end

  def free_percentage
    self.free_hosts / self.max_hosts * 100
  end

end
