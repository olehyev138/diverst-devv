module FieldData::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request)
      [:field, field: Field.base_preloads]
    end
  end
end
