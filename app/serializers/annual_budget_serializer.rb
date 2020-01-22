class AnnualBudgetSerializer < ApplicationRecordSerializer
  attributes :id, closed, :amount, :approved, :expenses, :available, :remaining, :leftover, :free, :reserved
end
