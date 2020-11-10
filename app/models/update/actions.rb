module Update::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request)
      case diverst_request.action
      when 'index' then []
      when 'show', 'create', 'update' then [ :field_data, :previous, :next, field_data: FieldData.base_preloads(diverst_request), previous: lesser_preloads(diverst_request) ]
      else []
      end
    end

    def lesser_preloads(diverst_request)
      [ :field_data, field_data: FieldData.base_preloads(diverst_request) ]
    end
  end
end
