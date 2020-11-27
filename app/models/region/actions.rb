module Region::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_query(diverst_request)
      "LOWER(#{self.table_name}.name) LIKE :search"
    end

    def base_left_joins(divert_request)
      :children
    end

    def valid_scopes
      []
    end

    def base_attributes_preloads
      []
    end

    # List of all attributes to preload.
    # Used when serializing a region itself
    def base_preloads(diverst_request)
      [
          :children,
          :parent,
          children: Group.base_preload_no_recursion(diverst_request),
          parent: Group.base_preload_no_recursion(diverst_request),
      ]
    end
  end
end
