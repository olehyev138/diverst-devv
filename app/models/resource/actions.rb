module Resource::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end
  module ClassMethods
    def valid_scopes
      ['not_archived', 'archived']
    end

    def base_preloads(diverst_request) ##
      case diverst_request.action
      when 'index' then [:file_attachment]
      when 'show' then [:folder, :file_attachment]
      else []
      end
    end
  end
end
