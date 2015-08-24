module FieldData
  def []=(field, value)
    self.store field.id.to_i, field.serialize_value(value)
  end

  def [](field)
    begin
      self.fetch(field.id)
    rescue
      nil
    end
  end
end
