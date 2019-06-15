class AnnualBudgetManager
  def initialize(group)
    @group = group
  end

  def reset
    # no need to reset annual budget because it is already set to 0
    return if @group.annual_budget == 0 || @group.annual_budget.nil?

    # at this point, group.annual_budget != 0 so we either find or create annual budget and update with group annual budget values
    # i.e annual budget, spent_budget, approved_budget and leftover_money
    find_or_create_annual_budget_and_update
    annual_budget = @group.annual_budgets.where(closed: false, enterprise_id: @group.enterprise_id).where.not(amount: 0).last

    # if no initiatives are present, then set annual budget values to 0
    if no_initiatives_present?
      @group.update({ annual_budget: 0, leftover_money: 0 })
      annual_budget.update(amount: 0, expenses: 0, available_budget: 0, approved_budget: 0, leftover_money: 0, enterprise_id: @group.enterprise_id)
      return true
    end

    # close annual_budget and create a new one for which new budget-related calculations can be made. New annual budget
    # has values set to 0
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

  def carry_over
    # no point in carrying over zero amount in leftover money
    return if @group.leftover_money == 0 || @group.leftover_money.nil?

    # find an opened annual budget with a non-zero leftover money
    annual_budget = @group.annual_budgets.where(closed: false, enterprise_id: @group.enterprise_id).where.not(leftover_money: 0).last

    return if annual_budget.nil?

    annual_budget.update(closed: true)

    # update new annual budget with leftover money
    new_annual_budget = AnnualBudget.find_or_create_by(closed: false, group_id: @group.id, enterprise_id: @group.enterprise_id)
    new_annual_budget.update(amount: annual_budget.leftover_money)

    return true if @group.update({ annual_budget: @group.leftover_money, leftover_money: 0 })
  end

  # this method to resolve inconsistencies where the annual budget of an initiative is not equal to annual budget of selected budget item
  def re_assign_annual_budget(budget_item_id, initiative_id)
    return if budget_item_id.nil? || budget_item_id.blank?

    budget_item_annual_budget = BudgetItem.find(budget_item_id).budget.annual_budget
    initiative = Initiative.find(initiative_id)
    if budget_item_annual_budget != initiative.annual_budget
      initiative.update(annual_budget_id: budget_item_annual_budget.id)
    end
  end


  private

  def no_initiatives_present?
    @group.initiatives.empty?
  end

  def find_or_create_annual_budget_and_update
    annual_budget = AnnualBudget.find_or_create_by(closed: false, group_id: @group.id, enterprise_id: @group.enterprise_id)
    annual_budget.update(amount: @group.annual_budget, available_budget: @group.available_budget,
                         leftover_money: @group.leftover_money, expenses: @group.spent_budget,
                         approved_budget: @group.approved_budget, enterprise_id: @group.enterprise_id)
  end

  def create_new_annual_budget
    annual_budget = AnnualBudget.find_or_create_by(closed: false, group_id: @group.id, enterprise_id: @group.enterprise_id)
  end
end
