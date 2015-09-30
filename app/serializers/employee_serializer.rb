class EmployeeSerializer < ActiveModel::Serializer
  attributes :id,
    :first_name,
    :last_name,
    :fields

  def fields
    fields = object.enterprise.fields
    fields_hash = []
    fields.each do |field|
      fields_hash << {
        title: field.title,
        value: field.string_value(object.info[field])
      }
    end

    fields_hash
  end
end
