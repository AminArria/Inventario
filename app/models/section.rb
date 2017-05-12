class Section < ApplicationRecord
  validates :api_id, :name, presence: true
end
