class RemoveGroupsBudgetsApproveFromPolicyGroupTemplates < ActiveRecord::Migration
  def change
    remove_column :policy_group_templates, :groups_budgets_approve, :boolean
  end
end
