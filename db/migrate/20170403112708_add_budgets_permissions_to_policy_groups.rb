class AddBudgetsPermissionsToPolicyGroups < ActiveRecord::Migration
  def change
    change_table :policy_groups do |t|
      t.boolean :groups_budgets_index, default: false, after: :groups_members_manage
      t.boolean :groups_budgets_request, default: false, after: :groups_budgets_index
    end
  end
end
