module NewsLink::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [
          :author,
          :group,
          :comments,
          :photos,
          :picture_attachment,
          comments: GroupMessageComment.base_preloads
      ]
    end
  end
end
