class AddFinishedToBudgetUser < ActiveRecord::Migration[5.2]
  def change
    add_column :budget_users, :finished_expenses, :boolean
    add_column :budget_users, :estimated, :decimal, precision: 20, scale: 4, default: 0
    BudgetUser.column_reload!
    BudgetUser.find_each do |bu|
      bu.update(finished_expenses: bu.budgetable.finished_expenses, estimated: bu.budgetable.estimated_funding)
    end
  end
end
