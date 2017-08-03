class DataCenter < ApplicationRecord
  has_many :clusters
  has_many :hosts, through: :clusters
end
