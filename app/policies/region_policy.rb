class RegionPolicy < ApplicationPolicy
  # def index?
  #   return true if create?
  #   return true if has_group_leader_permissions?('groups_index')
  #
  #   @policy_group.groups_index?
  # end
  #
  # def new?
  #   create?
  # end
  #
  # def show?
  #   (!private? && index?) || is_an_accepted_member?
  # end
  #
  # def create?
  #   return true if manage_all?
  #   return true if @policy_group.groups_manage?
  #   return true if has_group_leader_permissions?('groups_manage')
  #   return true if has_group_leader_permissions?('groups_create')
  #
  #   @policy_group.groups_create?
  # end
  #
  # def update?
  #   return true if manage?
  #   return true if has_group_leader_permissions?('group_settings_manage')
  #
  #   @record.owner == @user
  # end
  #
  # def destroy?
  #   update?
  # end
  #
  # def sort?
  #   index?
  # end
  #
  # delegate :private?, to: :record
  #
  # # Gets the parent permission based on what method this was called from
  # # @example
  # # def show?
  # #   # checks if user has `show` permission in parent group
  # #   parent_permissions?
  # # end
  # def parent_permissions?
  #   return false if @record.parent.nil?
  #
  #   parent_policy = ::GroupPolicy.new(@user, @record.parent)
  #
  #   # Gets the method name which this method was called from
  #   caller = caller_locations(1, 1)&.first&.label
  #   if parent_policy.respond_to?(caller)
  #     parent_policy.send(caller)
  #   else
  #     parent_policy.manage?
  #   end
  # end
  #
  # def has_group_leader_permissions?(permission)
  #   return false unless is_a_leader?
  #
  #   group_leader[permission] || false
  # end
  #
  # class Scope < Scope
  #   delegate :manage?, to: :policy
  #   delegate :index?, to: :policy
  #
  #   def resolve
  #     if manage?
  #       scope.where(enterprise_id: user.enterprise_id)
  #     elsif index?
  #       scope.left_joins(:user_groups)
  #           .where(enterprise_id: user.enterprise_id)
  #           .where('user_groups.user_id = ? OR groups.private = FALSE', user.id).all
  #     else
  #       scope.none
  #     end
  #   end
  # end
end
