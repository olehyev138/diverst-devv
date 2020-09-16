class GroupLeaderPolicy < GroupBasePolicy
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
    super && has_permission('groups_members_index')
  end
end
