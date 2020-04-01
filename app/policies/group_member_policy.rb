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

  def group_visibility_setting
    'members_visibility'
  end

  alias_method :view_members?, :index?

  def create?
    return true if record === user

    super
  end

  def destroy?
    return true if record == user

    super
  end
end
