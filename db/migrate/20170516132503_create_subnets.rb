class CreateSubnets < ActiveRecord::Migration[5.1]
  def change
    create_table :subnets do |t|
      t.integer :api_id
      t.string :base
      t.integer :mask
      t.references :section, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
