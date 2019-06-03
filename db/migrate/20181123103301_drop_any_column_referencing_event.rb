class DropAnyColumnReferencingEvent < ActiveRecord::Migration
  def change
    remove_column :fields, :event_id, :integer
  	remove_column :budgets, :event_id, :integer
  end
end
