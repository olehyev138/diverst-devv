module Segment::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_query
      "LOWER(#{self.table_name}.name) LIKE :search"
    end

    def base_preloads(diverst_request)
      [:field_rules, :order_rules, :group_rules, field_rules: [:field, field: Field.base_preloads(diverst_request)]]
    end
  end
end
