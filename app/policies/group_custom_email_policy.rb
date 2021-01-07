class GroupCustomEmailPolicy < ApplicationPolicy
  def index?
    return true if manage_all?
    return true if basic_group_leader_permission?('groups_members_index')

return true
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end
end
