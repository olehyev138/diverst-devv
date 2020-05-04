class FieldSerializer < ApplicationRecordSerializer
  attributes :field_definer_id, :field_definer_type, :operators, :options

  def operators
    object.operators
  end

  def field_definer_type
    object.field_definer_type&.constantize&.index_name
  end

  def options
    object.options_text.split if object.options_text.present?
  end

  def serialize_all_fields
    true
  end
end
