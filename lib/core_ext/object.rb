module DiverstObject
  def send_chain(arr)
    filtered = arr - excluded_scopes
    validated_scopes = filtered.select { |query_scope|
      if query_scope.kind_of?(String) || query_scope.kind_of?(Symbol)
        valid_scopes.include?(query_scope)
      else
        valid_scopes.include?(query_scope.first)
      end
    }
    Array(validated_scopes).inject(self) { |o, a| o.send(*a) }
  end
end

Object.include DiverstObject
