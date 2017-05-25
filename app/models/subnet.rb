class Subnet < ApplicationRecord
  belongs_to :section
  has_many :addresses

  validates :api_id, :base, :mask, presence: true
  validates :max_hosts, numericality: {greater_than_or_equal_to: 0}
  validates :public, inclusion: {in: [true, false]}, allow_blank: true

  before_create :define_type
  before_create :set_max_hosts

  def used_hosts
    self.addresses.where(active: true).count
  end

  def free_hosts
    self.max_hosts - self.used_hosts
  end

  def used_percentage
    self.used_hosts.to_f / self.max_hosts * 100
  end

  def free_percentage
    self.free_hosts.to_f / self.max_hosts * 100
  end

  def cidr
    "#{self.base}/#{self.mask}"
  end

  private

  def define_type
    case base
    when /^10\./, /^172\.(1[6-9]|2[0-9]|3[01])\./, /^192\.168\./
      self.public = false
    else
      self.public = true
    end
  end

  def set_max_hosts
    self.max_hosts = 2 ** (32-self.mask) - 2
  end
end
