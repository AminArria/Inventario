class CreateAggregates < ActiveRecord::Migration[5.1]
  def change
    create_table :aggregates do |t|
      t.string :name
      t.float :space_total
      t.float :space_used

      t.timestamps
    end
  end
end
