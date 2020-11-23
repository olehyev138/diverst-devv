class MoveEventBudgetData < ActiveRecord::Migration[5.2]
  def up
    Initiative.find_each do |event|
      if event.budget_item_id
        budget_user = BudgetUser.create(budgetable: event, budget_item_id: event.budget_item_id)
        event.expenses.find_each do |expense|
          expense.update(budget_user_id: budget_user.id)
          raise ActiveRecord::Rollback, expense.errors.full_messages.first if expense.errors.present?
        end
      end
    end
  end

  def down
    BudgetUser.find_each do |budget_user|
      if budget_user.initiative
        budget_user.initiative.update(budget_item_id: budget_user.budget_item_id)
        raise ActiveRecord::Rollback, budget_user.initiative.errors.full_messages.first if budget_user.initiative.errors.present?
      end
      budget_user.expenses.find_each do |expense|
        expense.update(
            initiative_id: expense.initiative_id,
            budget_user: nil
        )
        raise ActiveRecord::Rollback, expense.errors.full_messages.first if expense.errors.present?
      end
    end
    BudgetUser.destroy_all
  end
end
