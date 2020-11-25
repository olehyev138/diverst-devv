class BudgetUserSums < ApplicationRecord
  self.table_name = 'budget_users_sums'
  include MaterializedTable

  belongs_to :budget_user

  def readonly?
    true
  end
end
