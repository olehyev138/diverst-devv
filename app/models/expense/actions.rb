module Expense::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
  end
end
