class AddDiskToDataCenter < ActiveRecord::Migration[5.1]
  def change
    add_column :data_centers, :disk_total, :float
    add_column :data_centers, :disk_used, :float
  end
end
