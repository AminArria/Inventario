class AddHostsToSubnet < ActiveRecord::Migration[5.1]
  def change
    add_column :subnets, :max_hosts, :integer, default: 0
    add_column :subnets, :used_hosts, :integer, default: 0
  end
end
