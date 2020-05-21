class AnnualBudget < ActiveRecord::Base
  belongs_to :group
  belongs_to :enterprise
  has_many :initiatives
  has_many :initiative_expenses
  has_many :budgets

  # same as available_budget
  def approved_budget_leftover
    approved_budget - (initiatives.where(annual_budget_id: self.id).map { |i| i.current_expences_sum || 0 }).reduce(0, :+)
  end
end
