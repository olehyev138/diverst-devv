class ApplicationPolicy
  attr_reader :user, :policy_group, :params, :record, :group_leader_role_ids

  def initialize(user, record, params = nil)
    raise Pundit::NotAuthorizedError, 'must be logged in' unless user

    @user = user
    @record = record
    @params = params
    @group_leader_role_ids = @user.group_leaders.load.pluck(:user_role_id)
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

  def basic_group_leader_permission?(permission)
    if record&.is_a?(Group)
      @group_leader_role_id = GroupLeader.find_by(user_id: user&.id, group_id: record.id)&.user_role_id
    elsif record&.respond_to?(:group_id) # find the group of the record, eg. social link and check if user is group leader of group
      @group_leader_role_id = GroupLeader.find_by(user_id: user&.id, group_id: record.group_id)&.user_role_id
    end

    PolicyGroupTemplate.where(user_role_id: @group_leader_role_id).where("#{permission} = true").exists?
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
