class InitiativeUpdatePolicy < InitiativeBasePolicy
  def base_index_permission
    'initiatives_index'
  end

  def base_create_permission
    'initiatives_manage'
  end

  def base_manage_permission
    'initiatives_manage'
  end

  class Scope < Scope
    def resolve
      super(policy.base_index_permission)
    end
  end
end
