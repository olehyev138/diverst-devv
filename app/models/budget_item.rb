class BudgetItem < ApplicationRecord
  LEFTOVER_BUDGET_ITEM_ID = -1
  belongs_to :budget

  has_many :initiatives
  has_many :expenses, through: :initiatives

  has_many :finalized_initiatives, -> { where(finished_expenses: true) }, class_name: 'Initiative'
  has_many :finalized_expenses, through: :finalized_initiatives, source: :expenses, class_name: 'InitiativeExpense'

  has_many :unfinished_initiatives, -> { where(finished_expenses: false) }, class_name: 'Initiative'
  has_many :unfinished_expenses, through: :unfinished_initiatives, source: :expenses, class_name: 'InitiativeExpense'

  validates_length_of :title, maximum: 191
  validates :title, presence: true, length: { minimum: 2 }
  validates :estimated_amount, numericality: { less_than_or_equal_to: 999999, message: 'number of digits must not exceed 6' }
  validates :available_amount, numericality: { less_than_or_equal_to: :estimated_amount },
                               allow_nil: true, unless: -> { estimated_amount.blank? }

  scope :available, -> { where(is_done: false) }
  scope :allocated, -> { where(is_done: true) }

  def title_with_amount
    "#{title} ($#{available_amount})"
  end

  def spent
    expenses.sum('amount')
  end

  def reserved
    unfinished_initiatives.sum('estimated_funding') + finalized_expenditure
  end

  def available_amount
    return 0 if is_done || !budget.is_approved

    estimated_amount - reserved
  end

  def unspent
    estimated_amount - spent
  end

  def finalized_expenditure
    finalized_expenses.sum('amount')
  end

  def approve!
    self.update(available_amount: estimated_amount)
  end
end
