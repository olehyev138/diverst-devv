class RemoveGroupsBudgetsApproveFromPolicyGroups < ActiveRecord::Migration[5.1]
  def change
    remove_column :policy_groups, :groups_budgets_approve, :boolean
  end
end
