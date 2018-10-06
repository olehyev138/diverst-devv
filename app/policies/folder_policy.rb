class FolderPolicy < ApplicationPolicy
  def index?
    @policy_group.enterprise_resources_index?
  end
  
  def show?
    @policy_group.enterprise_resources_create?
  end
  
  def new?
    @policy_group.enterprise_resources_create?
  end

  def create?
    @policy_group.enterprise_resources_create?
  end

  def edit?
    update?
  end

  def update?
    @policy_group.enterprise_resources_manage?
  end

  def destroy?
    update?
  end
end
