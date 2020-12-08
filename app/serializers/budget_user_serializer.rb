class BudgetUserSerializer < ApplicationRecordSerializer
  attributes :budget_item

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
