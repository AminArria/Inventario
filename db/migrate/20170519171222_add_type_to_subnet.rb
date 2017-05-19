class AddTypeToSubnet < ActiveRecord::Migration[5.1]
  def change
    add_column :subnets, :type, :string
  end
end
