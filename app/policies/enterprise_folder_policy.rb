class EnterpriseFolderPolicy < ApplicationPolicy
  attr_accessor :user, :folder, :group_leader_role_ids

  def initialize(user, folder = nil, params = nil)
    self.user = user
    self.folder = folder
    self.group_leader_role_ids = user.group_leaders.pluck(:user_role_id)
  end

  def index?
    return true if create?
    return true if basic_group_leader_permission?('enterprise_resources_index')

    user.policy_group.enterprise_resources_index?
  end

  def show?
    index?
  end

  def new?
    create?
  end

  def create?
    return true if update?
    return true if basic_group_leader_permission?('enterprise_resources_create')

    user.policy_group.enterprise_resources_create?
  end

  def edit?
    update?
  end

  def update?
    return true if user.policy_group.manage_all?
    return true if basic_group_leader_permission?('enterprise_resources_manage')

    user.policy_group.enterprise_resources_manage?
  end

  def destroy?
    update?
  end

  def basic_group_leader_permission?(permission)
    PolicyGroupTemplate.where(user_role_id: group_leader_role_ids).where("#{permission} = true").exists?
  end

  class Scope < Scope
    def index?
      EnterpriseFolderPolicy.new(user, nil).index?
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
