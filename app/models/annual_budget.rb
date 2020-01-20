class AnnualBudget < ApplicationRecord
  belongs_to :group
  has_one :enterprise, through: :group

  has_many :budgets, dependent: :destroy
  has_many :budget_items, through: :budgets
  has_many :initiatives, through: :budget_items
  has_many :initiative_expenses, through: :initiatives, source: :expenses

  delegate :finalized, to: :initiatives, prefix: true
  delegate :finalized, to: :initiative_expenses, prefix: 'expenses'
  delegate :active, to: :initiatives, prefix: true
  delegate :active, to: :initiative_expenses, prefix: 'expenses'
  delegate :approved, to: :budgets, prefix: true
  delegate :approved, to: :budget_items, prefix: 'items'

  def close!
    update_column(:closed, true)
  end

  # same as available
  def approved
    items_approved
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
    expenses_finalized.sum('amount')
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
    initiatives_active.empty? && items_approved.where(is_done: false).empty?
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
