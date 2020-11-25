class BudgetUser < ApplicationRecord
  belongs_to :budgetable, polymorphic: true
  belongs_to :budget_item
  has_one :budget, through: :budget_item
  has_one :annual_budget, through: :budget
  has_many :expenses, dependent: :destroy, class_name: 'InitiativeExpense'

  def group
    budgetable&.group
  end

  polymorphic_alias :budgetable, Initiative
end
