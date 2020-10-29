class GroupLeaderPolicy < GroupBasePolicy
  def group_of(object)
    object.group || object.region.parent
  end

  def base_index_permission
    'group_leader_index'
  end

  def base_create_permission
    'group_leader_manage'
  end

  def base_manage_permission
    'group_leader_manage'
  end

  def create?
    super && has_at_least_permission('groups_members_index')
  end

  def manage?
    super && has_at_least_permission('groups_members_index')
  end
end
