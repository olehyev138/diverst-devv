require 'securerandom'

module UserGroup::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def valid_scopes
      [
          :active,
          :pending,
          :inactive,
          :accepted_users,
          :all,
          :joined_from,
          :joined_to,
          :for_segment_ids
      ].map { |scope| scope.to_s }
    end

    def base_includes
      [ :user, :group ]
    end

    def base_preloads
      [ :group, :user, group: Group.base_attributes_preloads, user: User.base_attribute_preloads ]
    end
  end
end
