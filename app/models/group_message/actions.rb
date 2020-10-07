module GroupMessage::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [ :owner, :group, :comments, comments: GroupMessageComment.base_preloads ]
    end
  end
end
