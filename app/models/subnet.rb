class Subnet < ApplicationRecord
  belongs_to :section
  has_many :addresses

  validates :api_id, :base, :mask, presence: true
  validates :max_hosts, :used_hosts, numericality: {greater_than_or_equal_to: 0}
  validates_numericality_of :used_hosts, less_than_or_equal_to: :max_hosts
  validates :type, inclusion: {in: ['public', 'private']}, allow_blank: true

  before_save :define_type

  def free_hosts
    self.max_hosts - self.used_hosts
  end

  def used_percentage
    self.used_hosts / self.max_hosts * 100
  end

  def free_percentage
    self.free_hosts / self.max_hosts * 100
  end

  private

  def define_type
    case base
    when /^10\./, /^172\.(1[6-9]|2[0-9]|3[01])\./, /^192\.168\./
      self.type = 'private'
    else
      self.type = 'public'
    end
  end
end
