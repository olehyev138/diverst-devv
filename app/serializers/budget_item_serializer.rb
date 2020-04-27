class BudgetItemSerializer < ApplicationRecordSerializer
  attributes :title_with_amount, :available_amount

  def title_with_amount
    object.title_with_amount(event)
  end

  def available_amount
    object.available_for_event(event)
  end

  def event
    @event ||= @instance_options[:event]
  end

  def serialize_all_fields
    true
  end
end
