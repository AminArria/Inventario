class Aggregate < ApplicationRecord
  has_many :volumes
  belongs_to :storage_box

  validates :name, presence: true
  validates :name, uniqueness: {scope: :storage_box_id}
  validates :space_total, :space_used, numericality: {greater_than_or_equal_to: 0}
  validates :space_used, numericality: {less_than_or_equal_to: :space_total}

  def space_free
    space_total - space_used
  end
end
