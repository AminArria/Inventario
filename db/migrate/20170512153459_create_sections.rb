class CreateSections < ActiveRecord::Migration[5.1]
  def change
    create_table :sections do |t|
      t.integer :api_id
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
