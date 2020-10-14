module Resource::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end
  module ClassMethods
    def valid_scopes
      ['not_archived', 'archived']
    end

    def base_preloads(diverst_request)
      [:folder, :file_attachment]
    end
  end
end
