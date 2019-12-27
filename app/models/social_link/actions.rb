module SocialLink::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [ :author, :group, author: User.base_preloads, group: Group.base_preloads ]
    end
  end
end
