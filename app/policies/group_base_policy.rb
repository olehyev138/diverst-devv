class GroupBasePolicy < ApplicationPolicy
  attr_accessor :user, :group, :record, :group_leader_role_ids

  def initialize(user, context, params = {})
    super(user, context, params)

    # Check if it's a collection, a record, or a class
    if context.is_a?(Enumerable) # Collection/Enumerable
      self.group = context.first
      self.record = context.second
    elsif context.is_a?(Class) # Class
      # Set group using params if context is a class as this will be for
      # nested model actions such as index and create, which require a group
      self.group = ::Group.find(params[:group_id] || params.dig(context.model_name.param_key.to_sym, :group_id)) rescue nil
    elsif context.present?
      self.group = context.group
      self.record = context else # Record
    end
  end

  def is_a_member?
    UserGroup.where(user_id: user.id, group_id: group.id).exists?
  end

  def is_a_accepted_member?
    UserGroup.where(user_id: user.id, group_id: group.id, accepted_member: true).exists?
  end

  def is_a_leader?
    GroupLeader.where(user_id: user.id, group_id: group.id).exists?
  end

  def is_active_member?
    UserGroup.where(accepted_member: true, user_id: user.id, group_id: @record.id).exists?
  end

  def is_a_guest?
    !is_a_member?
  end

  def is_a_pending_member?
    UserGroup.where(accepted_member: false, user_id: user.id, group_id: @record.id).exists?
  end

  def index?
    return true if view_group_resource(base_manage_permission)
    return true if view_group_resource(base_create_permission)

    view_group_resource(base_index_permission)
  end

  def show?
    index?
  end

  def new?
    create?
  end

  def create?
    return true if manage_group_resource(base_manage_permission)

    manage_group_resource(base_create_permission)
  end

  def edit?
    update?
  end

  def update?
    manage_group_resource(base_manage_permission)
  end

  def destroy?
    update?
  end

  def base_index_permission
  end

  def base_create_permission
  end

  def base_manage_permission
  end

  protected

  def is_a_manager?(permission)
    return true if is_admin_manager?(permission)

    # return true if is_a_leader? &&  policy_group[permission]
    has_group_leader_permissions?(permission)
  end

  def is_admin_manager?(permission)
    # super admin
    return true if manage_all?

    # groups manager
    policy_group.groups_manage? && policy_group[permission]
  end

  def basic_group_leader_permission?(permission)
    PolicyGroupTemplate.where(user_role_id: group_leader_role_ids, enterprise_id: user.enterprise_id).where("#{permission} = true").exists?
  end

  def has_group_leader_permissions?(permission)
    return false unless is_a_leader?

    gl_permission = GroupLeader.attribute_names.include?(permission)
    pgt_permission = PolicyGroupTemplate.attribute_names.include?(permission)

    leaders = group.group_leaders.where(user_id: user.id)
    leaders = leaders.joins(:policy_group_template) if pgt_permission

    conditions = []
    conditions.append "(group_leaders.#{permission} = true)" if gl_permission
    conditions.append "(policy_group_templates.#{permission} = true)" if pgt_permission

    leaders.where(conditions.join(' OR ') || '(TRUE)').exists?
  end

  def view_group_resource(permission)
    return true if manage_group_resource(permission)

    # super admin
    return true if manage_all?
    # groups manager
    return true if policy_group.groups_manage? && policy_group[permission]
    # group leader
    return true if is_a_leader? &&  policy_group[permission]
    # group member
    return true if is_a_member? &&  policy_group[permission]

    false
  end

  def manage?
    manage_group_resource(base_manage_permission)
  end

  def manage_group_resource(permission)
    # super admin
    return true if manage_all?
    # groups manager
    return true if policy_group.groups_manage? && policy_group[permission]
    # group leader
    return true if has_group_leader_permissions?(permission)
    # group member
    return true if is_a_member? && policy_group[permission]

    false
  end

  def index?
    return true if view_group_resource(base_manage_permission)
    return true if view_group_resource(base_create_permission)

    view_group_resource(base_index_permission)
  end

  def show?
    index?
  end

  def new?
    create?
  end

  def create?
    return true if manage_group_resource(base_manage_permission)

    manage_group_resource(base_create_permission)
  end

  def edit?
    update?
  end

  def update?
    manage_group_resource(base_manage_permission)
  end

  def destroy?
    update?
  end

  def base_index_permission
  end

  def base_create_permission
  end

  def base_manage_permission
  end

  class Scope < Scope
    def quote_string(v)
      v.to_s.gsub(/\\/, '\&\&').gsub(/'/, "''")
    end

    def manage_all
      '(policy_groups.manage_all = true)'
    end

    def policy_group(permission)
      "policy_groups.#{quote_string(permission)} = true"
    end

    def group_manage(permission)
      "(policy_groups.groups_manage = true AND #{policy_group(permission)})"
    end

    def is_member(permission)
      "(user_groups.user_id = #{quote_string(user.id)} AND #{policy_group(permission)})"
    end

    def leader_policy(permission)
      "group_leaders.#{quote_string(permission)} = true"
    end

    def is_leader(permission)
      if group_has_permission(permission)
        "(group_leaders.user_id = #{quote_string(user.id)} AND #{leader_policy(permission)})"
      else
        'false'
      end
    end

    def group_has_permission(permission)
      GroupLeader.attribute_names.include?(permission)
    end

    delegate :index?, to: :policy
    delegate :group, to: :policy

    def group_base
      group.send(scope.all.klass.model_name.collection)
    end

    def resolve(permission)
      if group
        if index?
          group_base.merge(scope.all)
        else
          scope.none
        end
      else
        if scope <= Group
          scoped = scope.left_joins(:enterprise, :group_leaders, :user_groups)
        elsif scope.instance_methods.include?(:group)
          scoped = scope.left_joins(group: [:enterprise, :group_leaders, :user_groups])
        else
          scoped = scope.none
        end
        scoped
            .joins("JOIN policy_groups ON policy_groups.user_id = #{quote_string(user.id)}")
            .where('enterprises.id = ?', user.enterprise_id)
            .where([manage_all, group_manage(permission), is_member(permission), is_leader(permission)].join(' OR '))
      end
    end
  end
end
