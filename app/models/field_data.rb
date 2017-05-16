module FieldData
  def []=(field, value)
    store field.id.to_i, field.serialize_value(value)
  end

  def [](field)
    field.deserialize_value fetch(field.id)
  rescue # Since Hash#fetch will raise an exception if the key doesn't exist, we capture it to return nil
    nil
  end

  def merge(fields:, form_data:)
    return unless form_data

    fields.each do |field|
      form_data_value = form_data[field.id.to_s] || form_data[field.id] # Try both integer and string key

      self[field] = field.process_field_value form_data_value
    end
  end
end
