module Budget::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  def approve(approver)
    blocker = approval_blocker
    raise InvalidInputException.new({ message: blocker, attribute: :annual_budget }) if blocker
    raise InvalidInputException.new({ message: item.errors.full_messages.first, attribute: item.errors.messages.first.first }) unless update(approver: approver, is_approved: true)

    budget_items.each do |bi|
      bi.approve!
    end

    BudgetMailer.budget_approved(self).deliver_later if requester
    self
  end

  def decline(approver, reason = nil)
    assign_attributes(approver: approver, is_approved: false, decline_reason: reason)
    raise InvalidInputException.new({ message: item.errors.full_messages.first, attribute: item.errors.messages.first.first }) unless save(validate: false)

    BudgetMailer.budget_declined(self).deliver_later if requester
    self
  end

  def approval_blocker
    annual_budget_set? || annual_budget_open? || request_surplus?
  end

  module ClassMethods
    def base_includes
      [ :budget_items ]
    end
  end
end
