class InitiativeUpdatePolicy < ApplicationPolicy
  def index?
    return true if create?
    return true if basic_group_leader_permission?('initiatives_index')

    @policy_group.initiatives_index?
  end

  def create?
    return true if basic_group_leader_permission?('initiatives_manage')

    @policy_group.initiatives_manage?
  end

  def update?
    return true if basic_group_leader_permission?('initiatives_manage')
    return true if @policy_group.initiatives_manage?

    @record.owner == @user
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      scope.joins(initiative: { pillar: :outcome }).where(
        outcomes: {
          group_id: @user.enterprise.groups.pluck(:id)
        }
      )
    end
  end
end
