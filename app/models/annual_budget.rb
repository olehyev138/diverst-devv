class AnnualBudget < ApplicationRecord
  include AnnualBudget::Actions

  belongs_to :budget_head, polymorphic: true
  belongs_to :enterprise

  has_many :budgets, dependent: :destroy
  has_many :budget_items, through: :budgets
  has_many :budget_users, through: :budget_items
  has_many :initiatives, through: :budget_users, source_type: 'Initiative', source: :budgetable
  has_many :initiative_expenses, through: :budget_users, source: :expenses
  has_one :annual_budget_sums, class_name: 'AnnualBudgetSums'

  delegate :finalized, to: :initiatives, prefix: true
  delegate :finalized, to: :initiative_expenses, prefix: 'expenses'
  delegate :active, to: :budget_users, prefix: true
  delegate :approved, to: :budgets, prefix: true
  delegate :approved, to: :budget_items, prefix: 'items'

  polymorphic_alias :budget_head, Group
  polymorphic_alias :budget_head, Region

  scope :with_expenses, -> do
    select(
        '`annual_budgets`.*',
        'COALESCE(`spent`, 0) as spent',
        'COALESCE(`reserved`, 0) as reserved',
        'COALESCE(`requested_amount`, 0) as requested_amount',
        'COALESCE(`approved`, 0) as approved',
        'COALESCE(`user_estimates`, 0) as user_estimates',
        'COALESCE(`finalized_expenditures`, 0) as finalized_expenditures',
        'COALESCE(`approved`, 0) - COALESCE(`reserved`, 0) as available',
        'COALESCE(`user_estimates`, 0) - COALESCE(`spent`, 0) as unspent',
        'COALESCE(`approved`, 0) - COALESCE(`spent`, 0) as remaining',
        'COALESCE(`amount`, 0) - COALESCE(`spent`, 0) as leftover',
        'COALESCE(`amount`, 0) - COALESCE(`approved`, 0) as free'
      ).left_joins(:annual_budget_sums)
  end

  define_relation_method :count do |*args|
    query = self.all
    if query.group_values.blank?
      super(*args)
    else
      from_query = query.from_clause.value
      from_query.unscope(:select).unscope(:left_joins).select(:year, :quarter).distinct.count
    end
  end

  def currency
    'USD'
  end

  def self.expenses_column_names
    @expenses_column_names ||=
      [:amount, *(with_expenses.select_values.map { |a| a.split(' as ').second }.filter(&:itself))]
  end

  def self.data_of(group:, year: nil, quarter: nil, current: false)
    query = AnnualBudget.from(group.child_budgets.with_expenses, :annual_budgets).group(:year, :quarter)
    query = query.where(year: year) if year.present?
    query = query.where(quarter: quarter) if quarter.present?
    query = query.select(
      :year,
      :quarter,
      *(
        expenses_column_names.flat_map do |column|
          [
            "SUM(`#{column}`) as #{column}",
          ]
        end
      ),
      'MIN(`closed`) as closed',
      "#{group.id} as budget_head_id",
      '"Group" as budget_head_type',
    )
    query = query.having('NOT `closed`') if current
    query
  end

  def close!
    update_column(:closed, true)
  end

  def expenses; spent end

  def estimated; user_estimates end

  # same as available
  # def approved
  #   @approved ||= items_approved
  #                     .sum('estimated_amount')
  # end
  #
  # def reserved
  #   @reserved ||=
  #       expenses_finalized.sum('amount') + initiatives_active.sum('estimated_funding')
  # end
  #
  # def expenses
  #   @expenses ||= initiative_expenses.sum('amount')
  # end
  #
  # def estimated
  #   @estimated ||= initiatives.sum('estimated_funding')
  # end
  #
  # def finalized_expenditure
  #   @finalized_expenditure ||= expenses_finalized.sum('amount')
  # end
  #
  # def available
  #   @available ||= (approved - reserved)
  # end
  #
  # def remaining
  #   @remaining ||= (approved - expenses)
  # end
  #
  # def unspent
  #   @unspent ||= (estimated - expenses)
  # end
  #
  # def leftover
  #   @leftover ||= ((amount || 0) - expenses)
  # end
  #
  # def free
  #   @free ||= ((amount || 0) - approved)
  # end

  def can_be_reset?
    unless no_active_budget_users?
      errors.add(:budget_users, 'expenses still have not all been closed')
      return false
    end

    true
  end

  def self.open_users(enterprise)
    BudgetUser.includes(:budgetable).joins(:annual_budget).where(finished_expenses: false, annual_budgets: { enterprise_id: enterprise.id }).map(&:path)
  end

  def no_active_budget_users?
    budget_users_active.empty?
  end

  def no_open_budgets?
    items_approved.where(is_done: false).empty?
  end

  def reset!
    return false unless can_be_reset?

    # close annual_budget and create a new one for which new budget-related calculations can be made. New annual budget
    # has values set to 0
    return false unless update(closed: true)

    budgets.where(is_approved: nil).find_each { |b| b.decline(nil, 'Annual Budget is Closed') }

    group.create_annual_budget
  end

  def carryover!
    return false unless can_be_reset?

    update(closed: true)

    # update new annual budget with leftover money
    new_annual_budget = group.create_annual_budget
    return false unless new_annual_budget.update(amount: leftover)

    budgets.where(is_approved: nil).find_each { |b| b.decline(nil, 'Annual Budget is Closed') }

    new_annual_budget
  end

  class << self
    def default_year
      Time.now.year
    end

    def default_quarter
      (Time.now.to_i % 1.year) / 3.months + 1
    end

    def current_budget_period
      year = maximum(:year)
      [year, where(year: year).maximum(:quarter)]
    end

    def current_aggregate_type
      type_row = AnnualBudget
        .select(
          :year,
          :quarter,
          "MIN(`annual_budgets`.`budget_head_type` = 'Region') as region_type",
          'MAX(`groups`.`id`) IS NOT NULL AND MIN(`groups`.`parent_id` IS NULL) as parent_type'
        ).joins(
          "LEFT JOIN `groups` ON `groups`.`id` = `annual_budgets`.`budget_head_id` && `annual_budgets`.`budget_head_type` = 'Group'")
        .group(:year, :quarter)
        .order(year: :desc)
        .order(quarter: :desc)
        .limit(1)
        .to_a.first

      if type_row.region_type == 1
        :region
      elsif type_row.parent_type == 1
        :parent
      else
        :all
      end
    end

    def add_quarter(year:, quarter: nil, init_quarter: false)
      if quarter.blank? && !init_quarter
        [year + 1, nil]
      elsif quarter.blank? && init_quarter
        [year, default_quarter]
      elsif quarter >= 4
        [year + 1, 1]
      else
        [year, quarter + 1]
      end
    end

    def reset_budgets(amount: 0, init_quarter: false, type_override: nil, enterprise_id:, period_override: nil)
      old_year, old_quarter = period_override&.any? ? [nil, nil] : current_budget_period

      new_year, new_quarter = if period_override&.any?
        period_override
      elsif old_year.present?
        add_quarter(year: old_year, quarter: old_quarter, init_quarter: init_quarter)
      else
        [default_year, init_quarter ? default_quarter : nil]
      end

      AnnualBudget.update_all(closed: true)

      case type_override.presence || current_aggregate_type
      when :region
        initialize_regions_budgets(amount: amount, year: new_year, quarter: new_quarter, enterprise_id: enterprise_id)
      when :parent
        initialize_parent_budgets(amount: amount, year: new_year, quarter: new_quarter, enterprise_id: enterprise_id)
      when :all
        initialize_group_budgets(amount: amount, year: new_year, quarter: new_quarter, enterprise_id: enterprise_id)
      else
        raise StandardError, 'Current Aggregate Type Invalid'
      end

      [new_year, new_quarter]
    end

    def initialize_regions_budgets(amount: 0, year: default_year, quarter: default_quarter, enterprise_id:)
      Region.find_each do |region|
        AnnualBudget.create(
          budget_head: region, closed: false, amount: amount, year: year, quarter: quarter, enterprise_id: enterprise_id
        )
      end
    end

    def initialize_parent_budgets(amount: 0, year: default_year, quarter: default_quarter, enterprise_id:)
      Group.all_parents.find_each do |group|
        AnnualBudget.create(
          budget_head: group, closed: false, amount: amount, year: year, quarter: quarter, enterprise_id: enterprise_id
        )
      end
    end

    def initialize_group_budgets(amount: 0, year: default_year, quarter: default_quarter, enterprise_id:)
      Group.find_each do |group|
        AnnualBudget.create(
          budget_head: group, closed: false, amount: amount, year: year, quarter: quarter, enterprise_id: enterprise_id
        )
      end
    end
  end

  def reload
    super
  end
end
