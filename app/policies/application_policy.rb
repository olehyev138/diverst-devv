class ApplicationPolicy
  attr_reader :user, :policy_group, :params, :record

  def initialize(user, record, params = nil)
    raise Pundit::NotAuthorizedError, 'must be logged in' unless user

    @user = user
    @record = record
    @params = params
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
    scope.where(id: record&.id).exists?
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
    scope.where(id: record&.id).exists?
  end

  def edit?
    update?
  end

  def destroy?
    scope.where(id: record&.id).exists?
  end

  def manage_all?
    @policy_group.manage_all?
  end

  def scope
    policy = Pundit::PolicyFinder.new(record).policy
    policy::Scope.new(user, record.class).resolve
  end

  class Scope
    attr_reader :user, :scope, :permission, :policy, :params

    def initialize(user, scope, permission = nil, params: {})
      @user = user
      @scope = scope
      @permission = permission
      @params = params
      @policy_group = @user.policy_group

      policy_class = self.class.parent
      @policy = policy_class.new(user, scope.all.klass, params)
    end

    def resolve
      return scope.where(enterprise: @user.enterprise) if scope.has_attribute?(:enterprise_id)

      scope
    end
  end
end
