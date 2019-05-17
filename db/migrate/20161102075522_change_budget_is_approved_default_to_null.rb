class ChangeBudgetIsApprovedDefaultToNull < ActiveRecord::Migration[5.1]
  def change
    change_column :budgets, :is_approved, :boolean, :default => nil
  end
end
