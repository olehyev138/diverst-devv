class RemoveGroupsBudgetsApproveFromPolicyGroups < ActiveRecord::Migration
  def change
    remove_column :policy_groups, :groups_budgets_approve, :boolean
  end
end
