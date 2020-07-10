module BudgetItem::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  def close(diverst_request)
    raise BadRequestException.new "#{BudgetItem.name.titleize} ID required" if id.blank?

    unless self.close!
      raise InvalidInputException.new({ message: errors.full_messages.first, attribute: errors.messages.first.first })
    end

    self
  end

  module ClassMethods
    def base_includes
      [ :budget ]
    end

    def valid_scopes
      [ 'approved' ]
    end
  end
end
