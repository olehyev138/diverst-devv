class EnterpriseFolderPolicy < Struct.new(:user, :folder)
    
  def index?
    return true if create?
    user.policy_group.enterprise_resources_index?
  end
  
  def show?
    return true if user.policy_group.manage_all?
    user.policy_group.enterprise_resources_create?
  end
  
  def new?
    return true if user.policy_group.manage_all?
    user.policy_group.enterprise_resources_create?
  end

  def create?
    return true if update?
    user.policy_group.enterprise_resources_create?
  end

  def edit?
    update?
  end

  def update?
    return true if user.policy_group.manage_all?
    user.policy_group.enterprise_resources_manage?
  end

  def destroy?
    update?
  end
end
