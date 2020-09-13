module GroupMessage::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [ :owner, :group, :comments, owner: User.base_preloads, group: [:enterprise], comments: GroupMessageComment.base_preloads ]
    end
  end
end