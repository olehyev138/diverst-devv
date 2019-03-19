class AnnualBudgetManager
	def initialize(group)
		@group = group
	end

	def reset
      @group.initiatives.update_all(:estimated_funding => 0, :actual_funding => 0)
	  @group.initiatives.each { |initiative|  initiative.expenses.destroy_all }
      @group.budgets.destroy_all
	  return true if @group.update({:annual_budget => 0, :leftover_money => 0})		
	end
end