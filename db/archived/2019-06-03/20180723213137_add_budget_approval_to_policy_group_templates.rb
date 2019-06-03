class AddBudgetApprovalToPolicyGroupTemplates < ActiveRecord::Migration[5.1]
  def change
    add_column :policy_group_templates, :budget_approval, :boolean, default: false
  end
end
