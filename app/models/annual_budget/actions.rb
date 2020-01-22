module AnnualBudget::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def order_string(order_by, order)
      "annual_budgets.closed asc, #{order_by} #{order}"
    end
  end
end
