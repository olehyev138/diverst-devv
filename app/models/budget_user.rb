class BudgetUser < ApplicationRecord
  belongs_to :budgetable, polymorphic: true
  belongs_to :budget_item
  has_many :expenses, dependent: :destroy, class_name: 'InitiativeExpense'

  polymorphic_alias :budgetable, Initiative
end
