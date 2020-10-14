class PollSerializer < ApplicationRecordSerializer
  attributes :fields_count, :responses_count, :permissions, :targeted_users_count

  attributes_with_permission :fields, :groups, :segments, if: :show_action?

  def fields
    object.fields.map do |field|
      FieldSerializer.new(field, **instance_options)
    end
  end

  def serialize_all_fields
    true
  end
end
