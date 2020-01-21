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
    @approved ||= items_approved
                      .sum('estimated_amount')
  rescue
    nil
  end

  def reserved
    @reserved ||= initiatives.sum('estimated_funding')
  rescue
    nil
  end

  def expenses
    @expenses ||= initiative_expenses
                   .sum('amount')
  rescue
    nil
  end

  def finalized_expenditure
    @finalized_expenditure ||= expenses_finalized.sum('amount')
  rescue
    nil
  end

  def available
    @available ||= (approved - reserved)
  rescue
    nil
  end

  def remaining
    @remaining ||= (approved - expenses)
  rescue
    nil
  end

  def leftover
    @leftover ||= (amount - expenses)
  rescue
    nil
  end

  def free
    @free ||= amount - approved
  rescue
    nil
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

  def self.load_sums
    select(
        '`annual_budgets`.`*`,'\
        ' Sum(`initiative_expenses`.`amount`) as `expenses_sum`,'\
        ' Sum(`budget_items`.`estimated_amount`) as `approved_sum`,'\
        ' Sum(`initiatives`.`estimated_funding`) as `reserved_sum`')
        .left_joins(:initiative_expenses)
        .group(AnnualBudget.column_names).each do |ab|
      ab.instance_variable_set(:@expenses, ab.expenses_sum)
      ab.instance_variable_set(:@approved, ab.approved_sum)
      ab.instance_variable_set(:@reserved, ab.reserved_sum)
    end
  end
end
