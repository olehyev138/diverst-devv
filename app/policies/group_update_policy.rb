class GroupUpdatePolicy < GroupBasePolicy
  def base_index_permission
    'groups_insights_manage'
  end

  def base_create_permission
    'groups_insights_manage'
  end

  def base_manage_permission
    'groups_insights_manage'
  end

  class Scope < Scope
    def group_base
      group.updates
    end

    def resolve
      super(policy.base_index_permission)
    end
  end
end
