class FieldSerializer < ApplicationRecordSerializer
  attributes :enterprise, :field_definer_id, :field_definer_type, :operators

  def operators
    object.operators
  end

  def field_definer_type
    object.field_definer_type&.constantize&.index_name
  end

  def serialize_all_fields
    true
  end
end
