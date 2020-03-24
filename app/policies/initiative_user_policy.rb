class InitiativeUserPolicy < InitiativeBasePolicy
  def base_index_permission
    'initiatives_index'
  end

  def base_create_permission
    'initiatives_create'
  end

  def base_manage_permission
    'initiatives_manage'
  end

  def group_visibility_setting
    'event_attendance_visibility'
  end

  def manage_group_resource(permission)
    manage_all?
  end

  def join?
    return true if manage_all?
    return true if group[:upcoming_events_visibility] == 'public'

    is_a_member? && ['managers_only', 'leaders_only'].exclude?(group[:upcoming_events_visibility])
  end

  def leave?
    true
  end

  class Scope < Scope
    def is_member(permission)
      "(groups.event_attendance_visibility IN ('global', 'group') AND user_groups.user_id = #{quote_string(user.id)} AND #{policy_group(permission)})"
    end

    def is_not_a_member(permission)
      "(groups.event_attendance_visibility IN ('global') AND #{policy_group(permission)})"
    end

    def group_base
      (group.initiatives.custom_or(group.participating_initiatives)).initiative_users
    end

    def resolve
      super(policy.base_index_permission)
    end
  end
end
