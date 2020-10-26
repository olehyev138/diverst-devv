module Field::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_select
      %w[`fields`.`id` `fields`.`title`]
    end

    def base_query(diverst_request)
      "LOWER(#{self.table_name}.title) LIKE :search"
    end

    def base_preloads(diverst_request)
      case diverst_request.action
      when 'index' then []
      when 'show' then [:field_definer]
      else []
      end
    end
  end
end
