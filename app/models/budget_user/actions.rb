require 'base64'
require 'rqrcode'

module BudgetUser::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  def finalize_expenses(diverst_request)
    raise BadRequestException.new "#{self.class.name.titleize} ID required" if id.blank?

    unless self.finish_expenses!
      raise InvalidInputException.new({ message: errors.full_messages.first, attribute: errors.messages.first.first })
    end

    self
  end

  module ClassMethods

  end
end
