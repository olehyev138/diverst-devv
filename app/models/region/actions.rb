module Region::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_query
      "LOWER(#{self.table_name}.name) LIKE :search"
    end

    def base_left_joins
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
    def base_preloads
      [ children: Group.base_preload_no_recursion, parent: Group.base_preload_no_recursion ]
    end
  end
end
