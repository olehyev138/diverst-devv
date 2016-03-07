class InitiativeUpdatePolicy < ApplicationPolicy
  def index?
    @policy_group.initiatives_index?
  end

  def create?
    @policy_group.initiatives_manage?
  end

  def update?
    return true if @policy_group.initiatives_manage?
    @record.owner == @user
  end

  def destroy?
    return true if @policy_group.initiatives_manage?
    @record.owner == @user
  end

  class Scope < Scope
    def resolve
      scope.joins(initiative: { pillar: :outcome }).where(
        outcomes: {
          enterprise_id: @user.enterprise.id
        }
      )
    end
  end
end