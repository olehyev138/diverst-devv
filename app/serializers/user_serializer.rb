class UserSerializer < ApplicationRecordSerializer
  attributes :enterprise, :last_name, :fields

  # Serialize all user fields, including the custom attributes listed above, and excluding the `excluded_keys`
  def serialize_all_fields
    true
  end

  def excluded_keys
    [:password_digest]
  end

  # Custom attributes

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
end
