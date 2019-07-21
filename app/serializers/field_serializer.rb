class FieldSerializer < ApplicationRecordSerializer
  attributes :enterprise, :group, :poll, :initiative

  def serialize_all_fields
    true
  end
end
