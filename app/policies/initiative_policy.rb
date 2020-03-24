class InitiativePolicy < GroupBasePolicy
  def base_index_permission
    'initiatives_index'
  end

  def base_create_permission
    'initiatives_create'
  end

  def base_manage_permission
    'initiatives_manage'
  end

  def finish_expenses?
    update?
  end

  def group_visibility_setting
    'upcoming_events_visibility'
  end

  def update?
    Initiative === record ? record.owner == user || super : super
  end

  def fields?
    update?
  end

  def create_field?
    update?
  end

  def updates?
    update?
  end

  def metrics_index?
    update?
  end

  def update_prototype?
    updates?
  end

  def create_update?
    update?
  end

  def archive?
    update?
  end

  def un_archive?
    update?
  end

  # Miscellaneous

  def join_event?
    InitiativeUserPolicy.new(self, InitiativeUser).join?
  end

  # todo: fix and test
  def show_calendar?
    return true if @record.segments.empty?
    return false if (@user.segments & @record.segments).empty?

    true
  end

  def user_is_guest_and_event_is_upcoming?
    @upcoming_events = @record.group.initiatives.upcoming
    is_a_guest? && (@upcoming_events.include? @record)
  end

  def user_is_guest_and_event_is_ongoing?
    @ongoing_events = @record.group.initiatives.ongoing
    is_a_guest? && (@ongoing_events.include? @record)
  end

  # todo: fix this logic, write a test for it
  def join_leave_button_visibility?
    @past_events = @record.group.initiatives.past
    return false if @past_events.include? @record

    user_is_guest_and_event_is_upcoming? || user_is_guest_and_event_is_ongoing?
  end

  def add_calendar_visibility?
    join_leave_button_visibility?
  end

  class Scope < Scope
    def is_member(permission)
      "(groups.upcoming_events_visibility IN ('public', 'non_member', 'group') AND user_groups.user_id = #{quote_string(user.id)} AND #{policy_group(permission)})"
    end

    def is_not_a_member(permission)
      "(groups.upcoming_events_visibility IN ('public', 'non_member') AND #{policy_group(permission)})"
    end

    def group_base
      group.initiatives.custom_or(group.participating_initiatives)
    end

    def resolve
      super(policy.base_index_permission)
    end
  end
end
