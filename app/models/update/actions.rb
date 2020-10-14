module Update::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request)
      [ :field_data, :previous, :next, field_data: FieldData.base_preloads(diverst_request), previous: lesser_preloads ]
    end

    def lesser_preloads
      [ :field_data, field_data: FieldData.base_preloads(diverst_request) ]
    end
  end
end
