module SocialLink::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [ :author ]
    end
  end
end
