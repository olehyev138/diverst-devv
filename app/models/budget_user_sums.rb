class BudgetUserSums < ApplicationRecord
  self.primary_key = 'budget_user_id'
  self.table_name = 'budget_users_sums'
  belongs_to :budget_user

  def readonly?
    true
  end
end
