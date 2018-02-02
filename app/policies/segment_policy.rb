class SegmentPolicy < ApplicationPolicy
  def index?
    @policy_group.segments_index?
  end

  def create?
    @policy_group.segments_create?
  end

  def update?
    return true if @policy_group.segments_manage?
    @record.owner == @user
  end

  def destroy?
    return true if @policy_group.segments_manage?
    @record.owner == @user
  end

end
