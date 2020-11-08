require 'securerandom'

module GroupLeader::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_query
      'LOWER(users.first_name) LIKE :search OR LOWER(users.last_name) LIKE :search OR LOWER(users.email) LIKE :search'
    end

    def base_includes
      [ :user ]
    end

    def base_preloads
      [:user, user: User.base_attribute_preloads ]
    end
  end
end
