class CreateClusters < ActiveRecord::Migration[5.1]
  def change
    create_table :clusters do |t|
      t.float :cpu_total
      t.float :cpu_used
      t.float :memory_total
      t.float :memory_used
      t.references :data_center, foreign_key: true

      t.timestamps
    end
  end
end
