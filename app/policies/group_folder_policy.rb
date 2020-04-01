class GroupFolderPolicy < GroupBasePolicy
  def base_index_permission
    'group_resources_index'
  end

  def base_create_permission
    'group_resources_create'
  end

  def base_manage_permission
    'group_resources_manage'
  end

  class Scope < Scope
    def is_member(permission)
      "(user_groups.user_id = #{quote_string(user.id)} AND #{policy_group(permission)})"
    end

    def is_not_a_member(permission)
      '(FALSE)'
    end

    def group_base
      group.folders
    end

    def resolve
      super(policy.base_index_permission)
    end
  end
end
