class RemoveBudgetManagersEmailFields < ActiveRecord::Migration
  def change
    remove_column :groups, :budget_manager_email, :string
    remove_column :enterprises, :budget_manager_email, :string
  end
end
