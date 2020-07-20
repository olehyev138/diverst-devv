class SerializerScopeNotDefinedException < StandardError
  def initialize
    super('Failed to pass scope to the Serializer. To do so, write `Serializer.new(object, scope: scope)` or `Serializer.new(object, **instance_options)`')
  end
end
