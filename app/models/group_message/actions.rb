module GroupMessage::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request)
      [ :owner, :group, :comments, comments: GroupMessageComment.base_preloads(diverst_request) ]
    end
  end
end
