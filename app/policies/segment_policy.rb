class SegmentPolicy < ApplicationPolicy
  def index?
    return true if create?
    return true if basic_group_leader_permission?('segments_index')

    @policy_group.segments_index?
  end

  def create?
    return true if update?
    return true if basic_group_leader_permission?('segments_create')

    @policy_group.segments_create?
  end

  def manage?
    return true if manage_all?
    return true if basic_group_leader_permission?('segments_manage')

    @policy_group.segments_manage?
  end

  def update?
    manage?
  end

  def destroy?
    manage?
  end

  def enterprise_segments?
    index?
  end

  class Scope < Scope
    def index?
      SegmentPolicy.new(user, nil).index?
    end

    def resolve
      if index?
        scope.where(enterprise_id: user.enterprise_id)
      else
        scope.none
      end
    end
  end
end
