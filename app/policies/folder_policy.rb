class FolderPolicy < ApplicationPolicy
  def index?
    @policy_group.enterprise_resources_index?
  end

  def create?
    @policy_group.enterprise_resources_create?
  end

  def edit?
    update?
  end

  def update?
    return true if @policy_group.enterprise_resources_manage?
  end

  def destroy?
    update?
  end
end
