class ChangeBudgetIsApprovedDefaultToNull < ActiveRecord::Migration
  def change
    change_column :budgets, :is_approved, :boolean, :default => nil
  end
end
