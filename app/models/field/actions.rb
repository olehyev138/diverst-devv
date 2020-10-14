module Field::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_query
      "LOWER(#{self.table_name}.title) LIKE :search"
    end

    def base_preloads(diverst_request)
      [:field_definer]
    end
  end
end
