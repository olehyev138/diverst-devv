class GroupEventsPolicy < GroupBasePolicy
  def base_index_permission
    'initiatives_index'
  end

  def base_create_permission
    'initiatives_create'
  end

  def base_manage_permission
    'initiatives_manage'
  end

  def view_upcoming_events?
    return true if user.policy_group.manage_all?

    # Ability to view upcoming events depends on settings level
    case group.upcoming_events_visibility
    when 'public', 'non_member'
      return true if user.policy_group.initiatives_manage?
      return true if user.policy_group.initiatives_create?
      return true if basic_group_leader_permission?('initiatives_manage')
      return true if basic_group_leader_permission?('initiatives_create')
      return true if basic_group_leader_permission?('initiatives_index')

      # Everyone can view upcoming events
      user.policy_group.initiatives_index?
    when 'group'
      index?
    when 'leaders_only'
      return true if is_a_manager?('initiatives_manage')
      return true if is_a_manager?('initiatives_create')

      is_a_manager?('initiatives_index')
    else
      return false
    end
  end

  def view_event_attendees?
    return true if user.policy_group.manage_all?

    case group.event_attendance_visibility
    when 'global'
      return true if user.policy_group.initiatives_manage?
      return true if basic_group_leader_permission?('initiatives_manage')

      # Everyone can see users
      user.policy_group.initiatives_index? && user.policy_group.groups_members_index?
    when 'group'
      return true if user.policy_group.initiatives_manage?
      return true if basic_group_leader_permission?('initiatives_manage')

      is_a_accepted_member?
    when 'managers_only'
      is_a_manager?('initiatives_manage')
    else
      false
    end
  end

  def view_upcoming_and_ongoing_events?
    view_upcoming_events?
  end

  def able_to_join_events?
    # super admins can join group
    return true if user.policy_group.manage_all?

    case group.upcoming_events_visibility
    when 'public'
      # allows only members of group to join group event
      return true if user.is_member_of?(group)

      return false
    when 'non_member'
      # allows non members of group to join group event as long as they have the following permissions set to true
      return true if user.policy_group.initiatives_manage?
      return true if user.policy_group.initiatives_create?
      return true if basic_group_leader_permission?('initiatives_manage')
      return true if basic_group_leader_permission?('initiatives_create')
      return true if basic_group_leader_permission?('initiatives_index')

      user.policy_group.initiatives_index?
    when 'group'
      index?
    when 'leaders_only'
      # to join a group event user must have leaders permission defined below.
      return true if is_a_manager?('initiatives_manage')
      return true if is_a_manager?('initiatives_create')

      is_a_manager?('initiatives_index')
    else
      return false
    end
  end
end

# values for group.upcoming_events visibility--> public(- View Only (non group members cannot join events), non_member- Allow Non Members to Join (non group members can join events)
