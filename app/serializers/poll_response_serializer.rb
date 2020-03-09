class PollResponseSerializer < ApplicationRecordSerializer
  attributes :poll, :user, :fields

  def fields
    fields = object.poll.fields
    fields_hash = []

    fields.each do |field|
      fields_hash << {
        title: field.title,
        value: field.string_value(object[field])
      }
    end

    fields_hash
  end

  def serialize_all_fields
    true
  end
end
