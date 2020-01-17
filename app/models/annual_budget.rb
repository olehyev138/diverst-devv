class AnnualBudget < ApplicationRecord
  belongs_to :group
  has_one :enterprise, through: :group

  has_many :initiatives, through: :group
  has_many :initiative_expenses, through: :initiatives, source: :expenses

  has_many :finalized_initiatives, -> { where(finished_expenses: true) }, through: :group, source: :initiatives, class_name: 'Initiative'
  has_many :finalized_expenses, through: :finalized_initiatives, source: :expenses, class_name: 'InitiativeExpense'

  has_many :unfinished_initiatives, -> { where(finished_expenses: false) }, through: :group, source: :initiatives, class_name: 'Initiative'
  has_many :unfinished_expenses, through: :unfinished_initiatives, source: :expenses, class_name: 'InitiativeExpense'

  has_many :budgets, dependent: :destroy
  has_many :approved_budgets, -> { approved }, class_name: 'Budget'

  has_many :budget_items, through: :budgets
  has_many :approved_budget_items, through: :approved_budgets, source: :budget_items

  def close!
    update_column(:closed, true)
  end

  # same as available_budget
  def approved_budget
    approved_budget_items
        .sum('estimated_amount')
  end

  def reserved
    unfinished_initiatives.sum('estimated_funding') + finalized_expenditure
  end

  def spent_budget
    initiative_expenses
        .sum('amount')
  end

  def finalized_expenditure
    finalized_expenses.sum('amount')
  end

  def available_budget
    approved_budget - reserved
  end

  def unspent
    amount - spent_budget
  end

  def free
    amount - reserved_budget
  end

  def leftover
    amount - approved_budget
  end
end
