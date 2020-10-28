class InitiativePolicy < GroupBasePolicy
  def get_group_id(context = nil)
    super(context, :group_id) || super
  end

  def group_id_param
    :owner_group_id
  end

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

  def archived?
    policy_group.manage_all? || policy_group.auto_archive_manage?
  end

  def attendees?
    InitiativeUserPolicy.new(self, InitiativeUser).index?
  end

  def update?
    (record.owner == user if Initiative === record) || super
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

  alias_method :un_archive?, :archived?

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

    delegate :archived?, to: :policy

    def resolve
      if index? && action == :index
        super(policy.base_index_permission)
      elsif archived? && action == :archived
        scope.archived.left_joins(:enterprise).where(enterprises: { id: user.enterprise.id })
      end
    end
  end
end
