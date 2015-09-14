module FieldData
  def []=(field, value)
    self.store field.id.to_i, field.serialize_value(value)
  end

  def [](field)
    begin
      field.deserialize_value self.fetch(field.id)
    rescue # Since Hash#fetch will raise an exception if the key doesn't exist, we capture it to return nil
      nil
    end
  end
end
