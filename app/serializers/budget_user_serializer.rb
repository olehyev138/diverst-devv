class BudgetUserSerializer < ApplicationRecordSerializer
  attributes :budget_item

  attributes_with_permission :expenses, if: :with_budget?

  def with_budget?
    instance_options[:with_budget] && !instance_options[:ignore_expenses]
  end

  def expenses
    object.spent.map do |expense|
      InitiativeExpenseSerializer.new(expense, **instance_options, ignore_budget_user: true).as_json
    end
  end

  def budget_item
    BudgetItemSerializer.new(object.budget_item, **instance_options).as_json
  end

  def event
    @event ||= @instance_options[:event]
  end

  def serialize_all_fields
    true
  end
end
