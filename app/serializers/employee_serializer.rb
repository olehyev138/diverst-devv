class EmployeeSerializer < ActiveModel::Serializer
  attributes :id,
    :first_name,
    :last_name,
    :fields

  def fields
    fields = object.enterprise.mobile_fields.map(&:field)
    fields_hash = []
    fields_hash << {
      title: "Topic of conversation",
      value: match.topic.statement
    }

    fields.each do |field|
      fields_hash << {
        title: field.title,
        value: field.string_value(object.info[field])
      }
    end

    fields_hash
  end

  def last_name
    "#{(object.last_name || "")[0].capitalize}."
  end
end
