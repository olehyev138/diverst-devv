class ChangeAnnualBudgetGroupToPolymorphic < ActiveRecord::Migration[5.2]
  def change
    add_reference :annual_budgets, :budget_head, polymorphic: true, index: true

    reversible do |change|
      AnnualBudget.column_reload!
      change.up do
        AnnualBudget.find_each do |ab|
          next unless ab.group_id.present?
          ab.update(budget_head_id: ab.group_id, budget_head_type: 'Group')
        end
      end

      change.down do
        AnnualBudget.find_each do |ab|
          next unless ab.budget_head_type == 'Group'
          ab.update(group_id: ab.budget_head_id)
        end
      end
    end
  end
end
