class GroupMemberPolicy < GroupBasePolicy
  def base_index_permission
    'groups_members_index'
  end

  def base_create_permission
    'groups_members_manage'
  end

  def base_manage_permission
    'groups_members_manage'
  end

  def view_members?
    return true if user.policy_group.manage_all?

    # Ability to view members depends on settings level
    case group.members_visibility
    when 'global'
      return true if user.policy_group.groups_members_manage?
      return true if basic_group_leader_permission?('groups_members_manage')
      return true if basic_group_leader_permission?('groups_members_index')

      # Everyone can see users
      user.policy_group.groups_members_index?
    when 'group'
      index?
    when 'managers_only'
      return true if is_a_manager?('groups_members_manage')

      is_a_manager?('groups_members_index')
    else
      false
    end
  end

  def create?
    return true if record === user

    super
  end

  def destroy?
    return true if record == user

    super
  end
end
