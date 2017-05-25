class Address < ApplicationRecord
  belongs_to :subnet

  validates :api_id, :ip, presence: true
  validates :active, inclusion: {in: [true, false]}

end
