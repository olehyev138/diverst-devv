module PollResponse::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request)
      case diverst_request.action
      when 'index' then [:user, :field_data, field_data: FieldData.base_preloads(diverst_request)]
      when 'show', 'create', 'update' then [:poll, :user, :field_data, field_data: FieldData.base_preloads(diverst_request)]
      else []
      end
    end
  end
end
