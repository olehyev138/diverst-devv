class BudgetSerializer < ApplicationRecordSerializer
  attributes :approver, :requested_amount, :available_amount, :group_id, :annual_budget_id,
             :status, :requested_at, :item_count, :description, :requester, :permissions, :currency

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
    true
  end
end
