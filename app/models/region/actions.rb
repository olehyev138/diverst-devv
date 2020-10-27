module Region::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_query
      "LOWER(#{self.table_name}.name) LIKE :search OR LOWER(children_groups.name) LIKE :search"
    end

    def base_left_joins
      :children
    end

    def valid_scopes
      []
    end

    # List of all attributes to preload.
    # Used when serializing a region itself
    def base_preloads
      base_preload_no_recursion | [ children: base_preload_no_recursion, parent: base_preload_no_recursion ]
    end

    # List of non-recursive attributes to preload.
    # Used as the preload fields for a groups children/parent as to prevent infinite recursion of base_preloads
    def base_preload_no_recursion
      base_attributes_preloads | [ :children, :parent ]
    end
  end
end
