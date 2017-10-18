class CreateVolumes < ActiveRecord::Migration[5.1]
  def change
    create_table :volumes do |t|
      t.string :name
      t.float :space_total
      t.float :space_used
      t.references :aggregate, foreign_key: true

      t.timestamps
    end
  end
end
