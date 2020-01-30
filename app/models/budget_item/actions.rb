module BudgetItem::Actions
  def self.included(klass)
    klass.extend ClassMethods
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
