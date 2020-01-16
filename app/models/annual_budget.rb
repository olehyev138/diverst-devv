class AnnualBudget < ApplicationRecord
  belongs_to :group
  belongs_to :enterprise
  has_many :initiatives, through: :group
  has_many :initiative_expenses, through: :initiatives, source: :expenses
  has_many :budgets, dependent: :destroy

  # same as available_budget
  def approved_budget_leftover
    approved_budget - (initiatives.reduce(0) { |sum, i| sum + (i.current_expences_sum || 0) })
  end
end
