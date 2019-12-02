require 'securerandom'

module UserGroup::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_includes
      [ :user, :group ]
    end

    def base_preloads
      [ :group, :user, group: Group.base_attributes_preloads, user: User.base_attribute_preloads ]
    end
  end
end
