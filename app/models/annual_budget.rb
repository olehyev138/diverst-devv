class AnnualBudget < ApplicationRecord
  include AnnualBudget::Actions

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
    @approved ||= items_approved
                      .sum('estimated_amount')
  end

  def reserved
    @reserved ||=
        expenses_finalized.sum('amount') + initiatives_active.sum('estimated_funding')
  end

  def expenses
    @expenses ||= initiative_expenses.sum('amount')
  end

  def estimated
    @estimated ||= initiatives.sum('estimated_funding')
  end

  def finalized_expenditure
    @finalized_expenditure ||= expenses_finalized.sum('amount')
  end

  def available
    @available ||= (approved - reserved)
  end

  def remaining
    @remaining ||= (approved - expenses)
  end

  def unspent
    @unspent ||= (estimated - expenses)
  end

  def leftover
    @leftover ||= ((amount || 0) - expenses)
  end

  def free
    @free ||= ((amount || 0) - approved)
  end

  def can_be_reset?
    unless no_active_initiatives?
      errors.add(:initiatives, 'There cannot be any initiatives with an open expense')
      return false
    end

    unless no_open_budgets?
      errors.add(:budget_items, 'There cannot be any open budgets')
      return false
    end

    true
  end

  def no_active_initiatives?
    initiatives_active.empty?
  end

  def no_open_budgets?
    items_approved.where(is_done: false).empty?
  end

  def reset!
    return false unless can_be_reset?

    # no need to reset annual budget because it is already set to 0
    return if amount == 0

    # close annual_budget and create a new one for which new budget-related calculations can be made. New annual budget
    # has values set to 0
    return false unless update(closed: true)

    budgets.where(is_approved: nil).find_each { |b| b.decline(nil, 'Annual Budget is Closed') }

    group.create_annual_budget
  end

  def carry_over!
    return false unless can_be_reset?

    # no point in carrying over zero amount in leftover money
    return if leftover == 0 || leftover.nil?

    update(closed: true)

    # update new annual budget with leftover money
    new_annual_budget = group.create_annual_budget
    return false unless new_annual_budget.update(amount: leftover)

    budgets.where(is_approved: nil).find_each { |b| b.decline(nil, 'Annual Budget is Closed') }

    new_annual_budget
  end

  def self.load_sums
    select(
        '`annual_budgets`.`*`,'\
        ' Sum(coalesce(`initiative_expenses`.`amount`, 0)) as `expenses_sum`,'\
        ' Sum(CASE WHEN `budgets`.`is_approved` = TRUE THEN coalesce(`budget_items`.`estimated_amount`, 0) ELSE 0 END) as `approved_sum`,'\
        ' Sum(coalesce(`initiatives`.`estimated_funding`, 0)) as `reserved_sum`')
        .left_joins(:initiative_expenses)
        .group(AnnualBudget.column_names).each do |ab|
      ab.instance_variable_set(:@expenses, ab.expenses_sum)
      ab.instance_variable_set(:@approved, ab.approved_sum)
      ab.instance_variable_set(:@reserved, ab.reserved_sum)
    end
  end

  def reload
    @approved = nil
    @reserved = nil
    @expenses = nil
    @estimated = nil
    @finalized_expenditure = nil
    @remaining = nil
    @unspent = nil
    @leftover = nil
    @free = nil
    super
  end
end
