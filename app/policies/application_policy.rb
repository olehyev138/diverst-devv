class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user

    @user = user
    @record = record
    @policy_group = @user.policy_group || @user.enterprise.default_policy_group
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    scope.where(:id => record.id).exists?
  end

  def edit?
    update?
  end

  def destroy?
    scope.where(:id => record.id).exists?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
      @policy_group = @user.policy_group
    end

    def resolve
      scope.where(enterprise: @user.enterprise)
    end
  end
end
