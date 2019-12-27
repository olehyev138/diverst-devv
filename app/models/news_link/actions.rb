module NewsLink::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [ :author, :group, :comments, :photos, author: User.base_preloads, group: [:enterprise], comments: GroupMessageComment.base_preloads ]
    end
  end
end
