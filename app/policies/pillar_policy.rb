class PillarPolicy < GroupBasePolicy
  def base_index_permission
    'initiatives_create'
  end

  def base_create_permission
    'initiatives_create'
  end

  def base_manage_permission
    'initiatives_manage'
  end

  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  class Scope < Scope
    def group_base
      group.pillars
    end

    def resolve
      super(policy.base_index_permission)
    end
  end
end
