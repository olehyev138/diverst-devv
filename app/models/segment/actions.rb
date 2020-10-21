module Segment::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_query(diverst_request)
      "LOWER(#{self.table_name}.name) LIKE :search"
    end

    def base_preloads(diverst_request) ##
      case diverst_request.action
      when 'index' then []
      when 'show' then [:field_rules, :order_rules, :group_rules, field_rules: [:field, field: Field.base_preloads(diverst_request)]]
      else []
      end
    end
  end
end
