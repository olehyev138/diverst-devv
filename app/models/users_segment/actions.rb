require 'securerandom'

module UsersSegment::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_includes(diverst_request) ##
      [ :user, :segment ]
    end
  end
end
