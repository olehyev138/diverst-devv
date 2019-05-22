class AnnualBudgetManager
  def initialize(group)
    @group = group
  end

  def reset
    return if @group.annual_budget == 0 || @group.annual_budget.nil?

    find_or_create_annual_budget_and_update
    annual_budget = @group.annual_budgets.where(closed: false).where.not(amount: 0).last

    return if annual_budget.nil?

    if no_initiatives_present?
      @group.update({ annual_budget: 0, leftover_money: 0 })
      annual_budget.update(amount: 0, expenses: 0, available_budget: 0, approved_budget: 0, leftover_money: 0)
      return true
    end

    annual_budget.update(closed: true) && create_new_annual_budget
    return true if @group.update({ annual_budget: 0, leftover_money: 0 })
  end

  def edit(annual_budget_params)
    return if annual_budget_params['annual_budget'].to_i == 0

    @group.update(annual_budget_params) unless annual_budget_params.empty?
    find_or_create_annual_budget_and_update
  end

  def approve
    find_or_create_annual_budget_and_update
  end


  private

  def no_initiatives_present?
    @group.initiatives.empty?
  end

  def find_or_create_annual_budget_and_update
    annual_budget = AnnualBudget.find_or_create_by(closed: false, group_id: @group.id)
    annual_budget.update(amount: @group.annual_budget, available_budget: @group.available_budget,
                         leftover_money: @group.leftover_money, expenses: @group.spent_budget,
                         approved_budget: @group.approved_budget)
  end

  def create_new_annual_budget
    annual_budget = AnnualBudget.find_or_create_by(closed: false, group_id: @group.id)
  end
end
