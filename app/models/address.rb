class Address < ApplicationRecord
  belongs_to :subnet

  validates :api_id, :ip, presence: true
  validates :active, inclusion: {in: [true, false]}

  after_update :update_used_hosts
  after_create :increase_used_hosts
  after_destroy :decrease_used_hosts

  private

  def update_used_hosts
    if self.active_changed?
      self.subnet.update_used_hosts!(self.active ? 1 : -1)
    end
  end

  def increase_used_hosts
    self.subnet.update_used_hosts!(self.active ? 1 : 0)
  end

  def decrease_used_hosts
    self.subnet.update_used_hosts!(self.active ? -1 : 0)
  end
end
