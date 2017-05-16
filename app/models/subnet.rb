class Subnet < ApplicationRecord
  belongs_to :section

  validates :api_id, :base, :mask, presence: true
end
