class SegmentPolicy < ApplicationPolicy
  def index?
    @policy_group.segments_index?
  end

  def create?
    @policy_group.segments_create?
  end

  class Scope < Scope
    def resolve
      return scope if @policy_group.segments_manage?
      scope.where(owner_id: user.id)
    end
  end
end
