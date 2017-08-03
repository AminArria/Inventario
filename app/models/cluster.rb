class Cluster < ApplicationRecord
  has_many :hosts
  belongs_to :data_center

  validates :cpu_total, :cpu_used, :memory_total, :memory_used, numericality: {greater_than_or_equal_to: 0}
  validates :cpu_used, numericality: {less_than: :cpu_total}
  validates :memory_used, numericality: {less_than: :memory_total}
end
