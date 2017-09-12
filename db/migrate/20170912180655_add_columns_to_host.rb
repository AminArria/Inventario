class AddColumnsToHost < ActiveRecord::Migration[5.1]
  def change
    add_column :hosts, :disk_total, :float
    add_column :hosts, :disk_used, :float
    add_column :hosts, :physical_cores, :integer
    add_column :hosts, :virtual_cores, :integer
  end
end
