class InitiativePolicy < ApplicationPolicy
  def index?
    return true if @policy_group.initiatives_index?

    #return true if user is a leader of at least one group
    @user.erg_leader?
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

  def join_leave_button_visibility?
    @past_events = @record.group.initiatives.past
    (@past_events.include? @record) ? false : true
  end

  def add_calendar_visibility?
    join_leave_button_visibility?
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
