class Section < ApplicationRecord
  has_many :subnets

  validates :api_id, :name, presence: true

  def public_addresses_count
    counts = {max: 0, used: 0, free: 0}
    self.subnets.where(public: true).each do |subnet|
      counts[:max] += subnet.max_hosts
      counts[:used] += subnet.used_hosts
      counts[:free] += subnet.free_hosts
    end

    if counts[:max] == 0
      counts[:used_percent] = 100
      counts[:free_percent] = 0
    else
      counts[:used_percent] = counts[:used].to_f / counts[:max].to_f * 100
      counts[:free_percent] = counts[:free].to_f / counts[:max].to_f * 100
    end

    counts
  end

end
