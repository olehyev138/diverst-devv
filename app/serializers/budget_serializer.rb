class BudgetSerializer < ApplicationRecordSerializer
  attributes :approver, :requested_amount, :available_amount, :group_id, :annual_budget_id,
             :status, :requested_at, :item_count, :description, :requester, :permissions, :currency

  [:spent, :reserved, :requested_amount, :user_estimates, :finalized_expenditures, :available_amount, :unspent, :approved_amount].each do |method|
    define_method(method) do
      object.send(method) if object.respond_to?(method)
    end
  end

  attributes_with_permission :budget_items, if: :singular_action?

  def singular_action?
    super || ['approve', 'decline'].include?(scope[:action])
  end

  def status
    object.approver.present? ? "#{object.status_title} by #{object.approver.name}" : object.status_title
  end

  def budget_items
    object.budget_items.map do |budget_item|
      BudgetItemSerializer.new(budget_item, **instance_options).as_json
    end
  end

  def policies
    super + [:approve?]
  end

  def serialize_all_fields
    false # true
  end
end
