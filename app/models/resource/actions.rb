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
      when 'index' then [:owner, :file_attachment, :file_blob]
      when 'show' then [:owner, :folder, :file_attachment, :file_blob]
      when 'create', 'update' then [:folder]
      else []
      end
    end
  end
end
