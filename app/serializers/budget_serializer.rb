class BudgetSerializer < ApplicationRecordSerializer
  attributes :approver, :requested_amount, :available_amount, :group_id, :annual_budget_id,
             :status, :requested_at, :item_count, :description, :requester, :budget_items

  def status
    object.approver.present? ? "#{object.status_title} by #{object.approver.name}" : object.status_title
  end

  def serialize_all_fields
    true
  end
end