class UserSerializer < ApplicationRecordSerializer
  def enterprise
    EnterpriseSerializer.new(object.enterprise).attributes
  end

  def fields
    fields = object.enterprise.mobile_fields.map(&:field)
    fields_hash = []

    fields.each do |field|
      fields_hash << {
        title: field.title,
        value: field.string_value(object.info[field])
      }
    end

    fields_hash
  end

  def last_name
    "#{(object.last_name || '')[0].capitalize}."
  end

  def excluded_keys
    [:password_digest]
  end

  def attributes
    hash = super
    hash[:last_name] = last_name
    hash[:fields] = fields
    hash[:enterprise] = enterprise
    hash
  end
end
