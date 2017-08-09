class DataCenter < ApplicationRecord
  has_many :clusters
  has_many :hosts, through: :clusters

  validates :name, presence: true
end
