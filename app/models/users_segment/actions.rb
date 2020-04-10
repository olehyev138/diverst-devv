require 'securerandom'

module UsersSegment::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_includes
      [ :user, :segment ]
    end

    def base_preloads
      [ user: User.base_preloads, segment: Segment.base_preloads ]
    end
  end
end
