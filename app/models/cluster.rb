class Cluster < ApplicationRecord
  has_many :hosts
  belongs_to :data_center

  validates :cpu_total, :cpu_used, :memory_total, :memory_used, numericality: {greater_than_or_equal_to: 0}
  validates :cpu_used, numericality: {less_than_or_equal_to: :cpu_total}
  validates :memory_used, numericality: {less_than_or_equal_to: :memory_total}

  before_validation :nil_to_cero

  private

  def nil_to_cero
    self.cpu_total ||= 0.0
    self.cpu_used ||= 0.0
    self.memory_total ||= 0.0
    self.memory_used ||= 0.0
  end
end
