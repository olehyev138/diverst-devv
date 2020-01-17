# TO BE DEPRECATED
class AnnualBudgetManager
  attr_reader :group

  def initialize(group)
    @group = group
  end

  def reset!
    # no need to reset annual budget because it is already set to 0
    return if group.annual_budget == 0 || group.annual_budget.nil?

    # at this point, group.annual_budget != 0 so we either find or create annual budget and update with group annual budget values
    # i.e annual budget, spent, approved and leftover_money
    find_or_create_annual_budget_and_update
    annual_budget = group.annual_budgets.where(closed: false, enterprise_id: group.enterprise_id).where.not(amount: 0).last

    # if no initiatives are present, then set annual budget values to 0
    if no_initiatives_present?
      group.update({ annual_budget: 0, leftover_money: 0 })
      annual_budget.update(amount: 0, expenses: 0, available: 0, approved: 0, leftover_money: 0, enterprise_id: group.enterprise_id)
      return true
    end

    # close annual_budget and create a new one for which new budget-related calculations can be made. New annual budget
    # has values set to 0
    annual_budget.update(closed: true) && create_new_annual_budget
    return true if group.update({ annual_budget: 0, leftover_money: 0 })
  end

  def edit(annual_budget_params)
    return if annual_budget_params['annual_budget'].to_i == 0

    annual_budget_params['leftover_money'] = (annual_budget_params['annual_budget'].to_f - group.annual_budget_approved.to_f) + group.annual_budget_available.to_f

    group.update(annual_budget_params) unless annual_budget_params.empty?
    find_or_create_annual_budget_and_update
  end

  def approve
    find_or_create_annual_budget_and_update
  end

  def carry_over!
    # no point in carrying over zero amount in leftover money
    return if group.annual_budget_remaining == 0 || group.annual_budget_remaining.nil?

    # find an opened annual budget with a non-zero leftover money
    annual_budget = group.annual_budgets.where(closed: false, enterprise_id: group.enterprise_id).where.not(leftover_money: 0).last

    return if annual_budget.nil?

    annual_budget.update(closed: true)

    # update new annual budget with leftover money
    new_annual_budget = AnnualBudget.find_or_create_by(closed: false, group_id: group.id, enterprise_id: group.enterprise_id)
    new_annual_budget.update(amount: annual_budget.leftover_money)

    return true if group.update({ annual_budget: group.annual_budget_remaining, leftover_money: 0 })
  end

  # this method to resolve inconsistencies where the annual budget of an initiative is not equal to annual budget of selected budget item
  def re_assign_annual_budget(budget_item_id, initiative_id)
    return if budget_item_id.to_i == 0 || budget_item_id.to_i < 0

    budget_item_annual_budget = BudgetItem.find(budget_item_id).budget.annual_budget
    initiative = Initiative.find(initiative_id)
    if budget_item_annual_budget != initiative.annual_budget
      initiative.update(annual_budget_id: budget_item_annual_budget.id)
    end
  end


  private

  def no_initiatives_present?
    group.initiatives.empty?
  end

  def find_or_create_annual_budget_and_update
    annual_budget = AnnualBudget.find_or_create_by(closed: false, group_id: group.id, enterprise_id: group.enterprise_id)
    annual_budget.update(amount: group.annual_budget, available: group.annual_budget_available,
                         leftover_money: group.annual_budget_remaining, expenses: group.annual_budget_spent,
                         approved: group.annual_budget_approved, enterprise_id: group.enterprise_id)
  end

  def create_new_annual_budget
    annual_budget = AnnualBudget.find_or_create_by(closed: false, group_id: group.id, enterprise_id: group.enterprise_id)
  end
end
