class AnnualBudgetManager
	def initialize(group)
	  @group = group
	end

	def edit(annual_budget_params)	
	  return if annual_budget_params['annual_budget'].to_i == 0
	  
	  @group.update(annual_budget_params) unless annual_budget_params.empty?  
	  find_or_create_annual_budget 
	end

	def approve
		find_or_create_annual_budget
	end

	
	private

	def find_or_create_annual_budget
	  annual_budget = AnnualBudget.find_or_create_by(closed: false, group_id: @group.id)
      annual_budget.update(amount: @group.annual_budget, available_budget: @group.available_budget, 
	  						leftover_money: @group.leftover_money, expenses: @group.spent_budget,
	  						approved_budget: @group.approved_budget)
	end
end