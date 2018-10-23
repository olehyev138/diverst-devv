class InitiativeExpensePolicy < ApplicationPolicy
  def index?
    return true if create?
    @policy_group.initiatives_index?
  end

  def create?
    return true if manage_all?
    @policy_group.initiatives_manage?
  end

  def update?
    return true if manage_all?
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