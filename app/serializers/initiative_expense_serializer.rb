class InitiativeExpenseSerializer < ApplicationRecordSerializer
  attributes :owner
  attributes_with_permission :budget_user, if: :show_budget_user?

  def show_budget_user?
    !instance_options[:ignore_budget_user]
  end

  def budget_user
    BudgetUserSerializer.new(object.budget_user, **instance_options, ignore_expenses: true)
  end

  def serialize_all_fields
    true
  end
end
