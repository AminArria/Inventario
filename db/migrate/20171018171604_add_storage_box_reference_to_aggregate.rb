class AddStorageBoxReferenceToAggregate < ActiveRecord::Migration[5.1]
  def change
    add_reference :aggregates, :storage_box, foreign_key: true
  end
end
