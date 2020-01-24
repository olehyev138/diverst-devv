module Budget::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def approve(approver)
      budget_items.each do |bi|
        bi.approve!
      end
      unless update(approver: approver, is_approved: true)
        raise InvalidInputException.new({ message: item.errors.full_messages.first, attribute: item.errors.messages.first.first })
      end

      BudgetMailer.budget_approved(self).deliver_later if requester
      self
    end

    def decline(approver, reason)
      assign_attributes(approver: approver, is_approved: false, decline_reason: reason)
      unless save(validate: false)
        raise InvalidInputException.new({ message: item.errors.full_messages.first, attribute: item.errors.messages.first.first })
      end

      BudgetMailer.budget_declined(self).deliver_later if requester
      self
    end
  end
end
