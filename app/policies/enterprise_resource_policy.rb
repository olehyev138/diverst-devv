class EnterpriseResourcePolicy < ApplicationPolicy
  def index?
    return true if create?
    return true if basic_group_leader_permission?('enterprise_resources_index')

    @policy_group.enterprise_resources_index?
  end

  def archived?
    policy_group.manage_all? || policy_group.auto_archive_manage?
  end

  alias_method :un_archive?, :archived?

  def create?
    return true if update?
    return true if basic_group_leader_permission?('enterprise_resources_create')

    @policy_group.enterprise_resources_create?
  end

  def edit?
    update?
  end

  def update?
    return true if manage_all?
    return true if basic_group_leader_permission?('enterprise_resources_manage')

    @policy_group.enterprise_resources_manage?
  end

  def destroy?
    update?
  end

  def archive?
    update?
  end

  class Scope < Scope
    def index?
      EnterpriseResourcePolicy.new(user, nil).index?
    end

    delegate :archived?, to: :policy

    def all_or_enterprise
      if params[:all]
        scope.left_joins(:enterprise, :group, :initiative, initiative: :group).where(enterprise_id: user.enterprise_id).or(
            scope.left_joins(:enterprise, :group, :initiative, initiative: :group).where(groups: { enterprise_id: user.enterprise_id }).or(
                scope.left_joins(:enterprise, :group, :initiative, initiative: :group).where(groups_initiatives: { enterprise_id: user.enterprise_id })
              ))
      else
        scope.where(enterprise_id: user.enterprise_id)
      end
    end

    def resolve
      if index? && action == :index
        all_or_enterprise
      elsif archived? && action == :archived
        all_or_enterprise.archived
      else
        scope.none
      end
    end
  end
end
