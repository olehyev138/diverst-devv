class OutcomeSerializer < ApplicationRecordSerializer
  attributes :group, :pillars

  def serialize_all_fields
    true
  end
end
