class InitiativePolicy < ApplicationPolicy
  def index?
    @policy_group.initiatives_index?
  end

  def show?
    index?
  end

  def create?
    @policy_group.initiatives_create?
  end

  def update?
    return true if @policy_group.initiatives_manage?
    @record.owner == @user
  end

  def destroy?
    return true if @policy_group.initiatives_manage?
    @record.owner == @user
  end

  def show_calendar?
    return true if @record.segments.empty?
    return false if (@user.segments & @record.segments).empty?
    true
  end

  class Scope < Scope
    def resolve
      scope.joins(pillar: { outcome: :group }).where(
        groups: {
          enterprise_id: @user.enterprise.id
        }
      )
    end
  end
end
