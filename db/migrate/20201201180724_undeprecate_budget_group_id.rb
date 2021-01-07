class UndeprecateBudgetGroupId < ActiveRecord::Migration[5.2]
  def change
    rename_column :budgets, :deprecated_group_id, :group_id
    up_only do
      Budget.find_each do |budget|
        budget.update(group: budget.parent_group)
      end
    end
  end
end
