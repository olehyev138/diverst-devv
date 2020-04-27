class AnnualBudgetSerializer < ApplicationRecordSerializer
  attributes :id, :closed, :group_id, :amount, :approved, :expenses, :available, :remaining, :leftover,
             :free, :reserved, :estimated, :unspent, :currency
end
