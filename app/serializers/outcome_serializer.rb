class OutcomeSerializer < ApplicationRecordSerializer
  attributes :group

  def serialize_all_fields
    true
  end
end
