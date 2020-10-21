require 'securerandom'

module UsersSegment::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_includes(diverst_request) ##
      [ :user, :segment ]
    end

    def base_preloads(diverst_request)
      [user: User.base_preloads(diverst_request)]
    end
  end
end
