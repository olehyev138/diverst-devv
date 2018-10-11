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

  def is_a_pending_member?
    @group = @record.group
    @group.pending_members.include? @user
  end

  def is_a_member?
    @group = @record.group
    @group.members.include? @user
  end

  def is_a_guest?
    is_a_pending_member? || !is_a_member?
  end
  
  def user_is_guest_and_event_is_upcoming?
    @upcoming_events = @record.group.initiatives.upcoming
    is_a_guest? && (@upcoming_events.include? @record)
  end

  def user_is_guest_and_event_is_onging?
    @ongoing_events = @record.group.initiatives.ongoing 
    is_a_guest? && (@ongoing_events.include? @record)
  end

  def join_leave_button_visibility?
    @past_events = @record.group.initiatives.past
    ((@past_events.include? @record) || user_is_guest_and_event_is_upcoming? || user_is_guest_and_event_is_onging?) ? false : true
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
