module Poll::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_query
      "LOWER(#{self.table_name}.title) LIKE :search"
    end

    def base_preloads
      [:fields, :groups, :segments, :enterprise]
    end
  end
end
