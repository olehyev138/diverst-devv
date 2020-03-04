class ApplicationPolicy
  attr_reader :user, :record, :group_leader_role_ids

  def initialize(user, record, params = nil)
    raise Pundit::NotAuthorizedError, 'must be logged in' unless user

    @user = user
    @record = record
    @group_leader_role_ids = @user.group_leaders.pluck(:user_role_id)
    @policy_group = @user.policy_group
  end

  def index?
    # TODO: Switch this back to 'false' after policies are made for each model
    # false
    true
  end

  def export_csv?
    index?
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    # TODO: Switch this back to 'false' after policies are made for each model
    # false
    true
  end

  def new?
    create?
  end

  def update?
    scope.where(id: record.id).exists?
  end

  def edit?
    update?
  end

  def destroy?
    scope.where(id: record.id).exists?
  end

  def manage_all?
    @policy_group.manage_all?
  end

  def basic_group_leader_permission?(permission)
    PolicyGroupTemplate.where(user_role_id: @group_leader_role_ids).where(permission.to_sym => true).exists?
  end

  def scope
    Pundit.policy_scope(user, record.class)
  end

  class Scope
    attr_reader :user, :scope, :permission

    def initialize(user, scope, permission = nil)
      @user = user
      @scope = scope
      @permission = permission
      @policy_group = @user.policy_group
    end

    def resolve
      return scope.where(enterprise: @user.enterprise) if scope.has_attribute?(:enterprise_id)

      scope
    end
  end
end
