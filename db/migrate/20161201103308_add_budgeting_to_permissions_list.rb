class AddBudgetingToPermissionsList < ActiveRecord::Migration
  def change
    change_table :policy_groups do |t|
      t.boolean :budget_approval, default: false
    end
  end
end
