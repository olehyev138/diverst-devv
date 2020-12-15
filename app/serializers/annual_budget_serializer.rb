class AnnualBudgetSerializer < ApplicationRecordSerializer
  attributes :id, :closed, :group_id, :amount, :approved, :spent, :available, :remaining, :leftover,
             :free, :reserved, :user_estimates, :unspent, :currency, :name, :type, :year, :quarter

  def type
    object.budget_head_type&.downcase
  end

  def name
    object.budget_head&.name
  end
end
