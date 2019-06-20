module BaseSerializer
  def serialized_keys
    object.attributes.symbolize_keys.except!(*excluded_keys)
  end

  def excluded_keys
    []
  end
end
