class OutcomePolicy < GroupBasePolicy
  def base_index_permission
    'initiatives_index'
  end

  def base_create_permission
    'initiatives_create'
  end

  def base_manage_permission
    'initiatives_manage'
  end

  def update?
    group&.owner == user || super
  end

  class Scope < Scope
    def group_base
      group.outcomes
    end

    def resolve
      super(policy.base_index_permission)
    end
  end
end
