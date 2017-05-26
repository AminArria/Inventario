class Section < ApplicationRecord
  has_many :subnets

  validates :api_id, :name, presence: true

  def public_addresses_count
    counts = {
      max:  self.subnets.where(public: true).sum("max_hosts"),
      used: self.subnets.where(public: true).joins(:addresses).count,
    }

    if counts[:max] == 0
      counts[:free] == 0
      counts[:used_percent] = 100
      counts[:free_percent] = 0
    else
      counts[:free] = counts[:max] - counts[:used]
      counts[:used_percent] = counts[:used].to_f / counts[:max].to_f * 100
      counts[:free_percent] = counts[:free].to_f / counts[:max].to_f * 100      
    end

    counts
  end

  def self.all_public_addresses_count
    counts = {
      count: Subnet.where(public: true).count,
      max:  Subnet.where(public: true).sum("max_hosts"),
      used: Subnet.where(public: true).joins(:addresses).count,
    }

    if counts[:max] == 0
      counts[:free] == 0
      counts[:used_percent] = 100
      counts[:free_percent] = 0
    else
      counts[:free] = counts[:max] - counts[:used]
      counts[:used_percent] = counts[:used].to_f / counts[:max].to_f * 100
      counts[:free_percent] = counts[:free].to_f / counts[:max].to_f * 100      
    end

    counts
  end

end
