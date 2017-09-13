class AddHostsAmountToCluster < ActiveRecord::Migration[5.1]
  def change
    add_column :clusters, :hosts_total, :integer
    add_column :clusters, :hosts_active, :integer
  end
end
