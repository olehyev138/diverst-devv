class AddAnnualBudgetManageToPolicyGroups < ActiveRecord::Migration
  def change
    add_column :policy_groups, :annual_budget_manage, :boolean, :default => false
  end
end
