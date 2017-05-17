class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.integer :api_id
      t.string :ip
      t.references :subnet, foreign_key: true
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
