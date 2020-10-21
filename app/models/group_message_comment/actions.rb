module GroupMessageComment::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request) ##
      [ :author, :group, author: :avatar_attachment, :avatar_blob ]
    end
  end
end
