class AddName < ActiveRecord::Migration[5.1]
  def change
    add_column :clusters, :name, :string
    add_column :hosts, :name, :string
  end
end
