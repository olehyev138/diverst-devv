class UserGroupPolicy < GroupBasePolicy
  def base_index_permission
    'groups_members_index'
  end

  def base_create_permission
    'groups_members_manage'
  end

  def base_manage_permission
    'groups_members_manage'
  end

  def group_visibility_setting
    'members_visibility'
  end

  def update?
    (record.user == user if UserGroup === record) || super
  end

  def join?
    group.active?
  end

  def leave?
    true
  end

  alias_method :view_members?, :index?
  alias_method :create?, :join?
  alias_method :destroy?, :leave?

  class Scope < Scope
    def is_member(permission)
      "(groups.members_visibility IN ('public', 'non_member', 'group') AND user_groups.user_id = #{quote_string(user.id)} AND #{policy_group(permission)})"
    end

    def is_not_a_member(permission)
      "(groups.members_visibility IN ('public', 'non_member') AND #{policy_group(permission)})"
    end

    def group_base
      group.user_groups
    end

    def resolve
      super(policy.base_index_permission)
    end
  end
end
