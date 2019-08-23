class FieldSerializer < ApplicationRecordSerializer
  attributes :enterprise, :group, :poll, :initiative, :operators

  def operators
    object.operators
  end

  def serialize_all_fields
    true
  end
end
