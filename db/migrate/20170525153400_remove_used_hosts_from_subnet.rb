class RemoveUsedHostsFromSubnet < ActiveRecord::Migration[5.1]
  def change
    remove_column :subnets, :used_hosts, :integer
  end
end
