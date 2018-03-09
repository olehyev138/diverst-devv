class AddIsPrivateToBudgetItems < ActiveRecord::Migration
  def change
    add_column :budget_items, :is_private, :boolean, default: false, after: :estimated_date
  end
end
