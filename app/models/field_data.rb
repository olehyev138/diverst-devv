module FieldData
  def []=(field, value)
    self.store field.id.to_i, field.serialize_value(value)
  end

  def [](field)
    begin
      value = self.fetch(field.id)
    rescue
      value = self.fetch(field.id.to_s)
    end

    field.deserialize_value(value)
  end
end
