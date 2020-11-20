class BudgetUser < ApplicationRecord
  belongs_to :budgetable, polymorphic: true
  belongs_to :budget_item

  polymorphic_alias :budgetable, Initiative
end
