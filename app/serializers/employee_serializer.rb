class EmployeeSerializer < ActiveModel::Serializer
  attributes :id,
    :first_name,
    :last_name,
    :info

  def info
    fields = object.enterprise.fields.select([:id, :title])
    Hash[object.info.map {|k, v| [fields.select{|field| field.id == k}[0].title, v] }]
  end
end
