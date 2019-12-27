module FieldData::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [:field, field: Field.base_preloads]
    end
  end
end
