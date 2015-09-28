class EmployeeSerializer < ActiveModel::Serializer
  attributes :id,
    :first_name,
    :last_name,
    :fields

  def fields
    fields = object.enterprise.fields.select([:id, :title])
    fields_hash = []
    fields.each do |field|
      fields_hash << {
        title: field.title,
        value: object.info[field]
      }
    end

    fields_hash
  end
end
