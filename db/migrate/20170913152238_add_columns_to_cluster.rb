class AddColumnsToCluster < ActiveRecord::Migration[5.1]
  def change
    add_column :clusters, :disk_total, :float
    add_column :clusters, :disk_used, :float
    add_column :clusters, :physical_cores, :integer
    add_column :clusters, :virtual_cores, :integer
  end
end
