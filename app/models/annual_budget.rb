class AnnualBudget < ActiveRecord::Base
  belongs_to :group
  belongs_to :enterprise
  has_many :initiatives
  has_many :initiative_expenses
  has_many :budgets
end
