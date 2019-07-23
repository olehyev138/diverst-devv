class AnnualBudgetSerializer < ApplicationRecordSerializer
  attributes :enterprise, :group

  def serialize_all_fields
    true
  end
end
