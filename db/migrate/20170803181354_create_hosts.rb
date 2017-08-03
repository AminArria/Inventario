class CreateHosts < ActiveRecord::Migration[5.1]
  def change
    create_table :hosts do |t|
      t.float :cpu_total
      t.float :cpu_used
      t.float :memory_total
      t.float :memory_used
      t.references :cluster, foreign_key: true

      t.timestamps
    end
  end
end
