class Section < ApplicationRecord
  has_many :subnets

  validates :api_id, :name, presence: true
end
