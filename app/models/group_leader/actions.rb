require 'securerandom'

module GroupLeader::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_query(diverst_request)
      'LOWER(users.first_name) LIKE :search OR LOWER(users.last_name) LIKE :search OR LOWER(users.email) LIKE :search'
    end

    def base_includes(diverst_request)
      [ :user, :group ]
    end

    # def base_preloads(diverst_request)
    #   [ :group, :user ]
    # end
  end
end
