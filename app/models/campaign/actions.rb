module Campaign::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request) ##
      case diverst_request.action
      when 'index' then []
      when 'show' then [ :image_attachment, :image_blob, :banner_attachment, :banner_blob, :groups, groups: Group.base_preloads(diverst_request) ]
      else []
      end
    end
  end
end
