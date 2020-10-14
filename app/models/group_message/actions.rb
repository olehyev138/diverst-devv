module GroupMessage::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request) ##
      case diverst_request.action
      when 'index' then [:owner, :group]
      when 'show' then [ :owner, :group, :comments, comments: GroupMessageComment.base_preloads(diverst_request) ]
      else []
      end
    end
  end
end
