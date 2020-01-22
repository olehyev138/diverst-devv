class AnnualBudgetSerializer < ApplicationRecordSerializer
  attributes :id, :amount, :approved, :expenses, :available, :remaining, :leftover, :free, :reserved
end
