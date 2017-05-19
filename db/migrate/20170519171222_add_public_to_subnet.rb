class AddPublicToSubnet < ActiveRecord::Migration[5.1]
  def change
    add_column :subnets, :public, :boolean
  end
end
