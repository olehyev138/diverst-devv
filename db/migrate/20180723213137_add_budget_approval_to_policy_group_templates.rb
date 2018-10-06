class AddBudgetApprovalToPolicyGroupTemplates < ActiveRecord::Migration
  def change
    add_column :policy_group_templates, :budget_approval, :boolean, default: false
  end
end
