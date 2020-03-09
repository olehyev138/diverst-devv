module GroupMessageComment::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [ :author, author: User.base_preloads ]
    end
  end
end
