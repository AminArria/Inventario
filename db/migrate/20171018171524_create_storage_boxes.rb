class CreateStorageBoxes < ActiveRecord::Migration[5.1]
  def change
    create_table :storage_boxes do |t|
      t.string :name

      t.timestamps
    end
  end
end
