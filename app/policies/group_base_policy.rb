class GroupBasePolicy < ApplicationPolicy
  attr_accessor :user, :group, :record, :group_leader_role_ids, :group_leader, :user_group

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
      self.record = context
    end

    if group
      @group_leader = GroupLeader.find_by(user_id: user.id, group_id: group.id)
      @user_group = UserGroup.find_by(user_id: user.id, group_id: group.id)
    end
  end

  def is_a_member?
    user_group.present?
  end

  def is_a_accepted_member?
    is_a_member? && user_group.accepted_member?
  end

  def is_a_leader?
    group_leader.present?
  end

  def is_active_member?
    UserGroup.where(accepted_member: true, user_id: user.id, group_id: @record.id).exists?
  end

  def is_a_guest?
    !is_a_member?
  end

  def is_a_pending_member?
    is_a_member? && !user_group.accepted_member?
  end

  def group_visibility_setting
  end

  def publicly_visible
    group_visibility_setting.present? ?
        ['public', 'global', 'non-members'].include?(group[group_visibility_setting]) : is_a_accepted_member?
  end

  def member_visible
    group_visibility_setting.present? ?
        ['public', 'global', 'non-members', 'group'].include?(group[group_visibility_setting]) : true
  end

  def leader_visible
    group_visibility_setting.present? ?
        ['public', 'global', 'non-members', 'group', 'managers_only', 'leaders_only'].include?(group[group_visibility_setting]) : true
  end

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

    group_leader[permission] || false
  end

  def view_group_resource(permission)
    return true if manage_group_resource(permission)

    # super admin
    return true if manage_all?
    # groups manager
    return true if policy_group.groups_manage? && policy_group[permission]
    # group leader
    return true if is_a_leader? && leader_visible && policy_group[permission]
    # group member
    return true if is_a_member? && member_visible && policy_group[permission]

    publicly_visible && policy_group[permission]
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
    return true if is_a_leader? && has_group_leader_permissions?(permission)
    # group member
    return true if is_a_member? && policy_group[permission]

    false
  end

  def index?
    if group
      return true if view_group_resource(base_manage_permission)
      return true if view_group_resource(base_create_permission)

      view_group_resource(base_index_permission)
    else
      policy_group[base_manage_permission] ||
          policy_group[base_create_permission] ||
          policy_group[base_index_permission]
    end
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

    def is_not_a_member(permission)
      nil
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

    def joined_with_group
      scope.left_joins(group: [:enterprise, :group_leaders, :user_groups])
    end

    def non_group_base(permission)
      if scope <= Group
        scoped = scope.left_joins(:enterprise, :group_leaders, :user_groups)
      elsif scope.instance_methods.include?(:group)
        scoped = joined_with_group
      else
        scoped = scope.none
      end
      scoped
          .joins("JOIN policy_groups ON policy_groups.user_id = #{quote_string(user.id)}")
          .where('enterprises.id = ?', user.enterprise_id)
          .where([manage_all, group_manage(permission), is_leader(permission), is_member(permission), is_not_a_member(permission)].compact.join(' OR '))
    end

    def resolve(permission)
      if group
        if index? && group.enterprise_id == user.enterprise_id
          group_base.merge(scope.all)
        else
          scope.none
        end
      else
        non_group_base(permission)
      end
    end
  end
end
