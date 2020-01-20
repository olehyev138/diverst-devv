class AnnualBudget < ApplicationRecord
  include CachedMethods

  belongs_to :group
  has_one :enterprise, through: :group

  has_many :budgets, dependent: :destroy
  has_many :approveds, -> { approved }, class_name: 'Budget'

  has_many :budget_items, through: :budgets
  has_many :approved_items, through: :approveds, source: :budget_items

  has_many :initiatives, through: :budget_items
  has_many :initiative_expenses, through: :initiatives, source: :expenses

  has_many :finalized_initiatives, -> { where(finished_expenses: true) }, through: :budget_items, source: :initiatives, class_name: 'Initiative'
  has_many :finalized_expenses, through: :finalized_initiatives, source: :expenses, class_name: 'InitiativeExpense'

  has_many :unfinished_initiatives, -> { where(finished_expenses: false) }, through: :budget_items, source: :initiatives, class_name: 'Initiative'
  has_many :unfinished_expenses, through: :unfinished_initiatives, source: :expenses, class_name: 'InitiativeExpense'

  cache :approved, :reserved, :expenses, :finalized_expenditure, :available,
        :unspent, :remaining, :leftover

  def close!
    update_column(:closed, true)
  end

  # same as available
  def approved
    approved_items
        .sum('estimated_amount')
  end

  def reserved
    initiatives.sum('estimated_funding')
  end

  def expenses
    initiative_expenses
        .sum('amount')
  end

  def finalized_expenditure
    finalized_expenses.sum('amount')
  end

  def available
    approved - reserved
  end

  def remaining
    approved - expenses
  end

  def leftover
    amount - expenses
  end

  def free
    amount - approved
  end

  def can_be_reset?
    unfinished_initiatives.empty? && approved_items.where(is_done: false).empty?
  end

  def reset!
    unless can_be_reset?
      errors.add(:initiatives, 'There cannot be any initiatives with an open expense')
      return
    end

    # no need to reset annual budget because it is already set to 0
    return if amount == 0

    # close annual_budget and create a new one for which new budget-related calculations can be made. New annual budget
    # has values set to 0
    annual_budget.update(closed: true) && group.create_annual_budget
  end

  def carry_over!
    unless can_be_reset?
      errors.add(:initiatives, 'There cannot be any initiatives with an open expense')
      return
    end

    # no point in carrying over zero amount in leftover money
    return if leftover == 0 || leftover.nil?

    update(closed: true)

    # update new annual budget with leftover money
    new_annual_budget = group.create_annual_budget
    return false unless new_annual_budget.update(amount: leftover)

    new_annual_budget
  end
end
