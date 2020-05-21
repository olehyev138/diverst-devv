class GroupBasePolicy < ApplicationPolicy
  attr_accessor :user, :group, :record, :group_leader_role_id, :group_leader, :user_group

  def initialize(user, context, params = {})
    case user
    when GroupPolicy
      @user = user.user
      @group = user.record
      @record = context
      @params = user.params
      @group_leader_role_id = user.group_leader_role_id
      @policy_group = user.policy_group
      @group_leader = user.group_leader
      @user_group = user.user_group
    else
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
        @group_leader = user.policy_group_leader(group.id)
        @user_group = user.policy_user_group(group.id)
        @group_leader_role_id = group_leader&.user_role_id
      end
    end
  end

  def is_a_member?
    user_group.present?
  end

  def is_an_accepted_member?
    is_a_member? && user_group.accepted_member?
  end

  def is_a_leader?
    group_leader.present?
  end

  alias_method :is_active_member?, :is_an_accepted_member?

  def is_a_guest?
    !is_a_member?
  end

  def is_a_pending_member?
    is_a_member? && !user_group.accepted_member?
  end

  def is_a_manager?
    is_admin_manager? || is_a_leader?
  end

  def is_admin_manager?
    manage_all? || policy_group.groups_manage?
  end

  def group_visibility_setting
  end

  def visibility
    case group[group_visibility_setting]
    when 'public', 'global', 'non-members', nil then 'public'
    when 'group' then 'group'
    when 'leaders_only', 'managers_only' then 'leader'
    else raise StandardError.new('Invalid Visibility Setting')
    end
  end

  def has_permission(permission)
    policy_group[permission] || has_group_leader_permissions?(permission)
  end

  def basic_group_leader_permission?(permission)
    PolicyGroupTemplate.where(user_role_id: group_leader_role_id, enterprise_id: user.enterprise_id).where("#{permission} = true").exists?
  end

  def has_group_leader_permissions?(permission)
    (is_a_leader? && group_leader[permission]) || false
  end

  def view_group_resource(permission)
    # super admin
    return true if manage_all?

    case visibility
    when 'public' then true
    when 'group' then is_a_member? || is_a_manager?
    when 'leader' then is_a_manager?
    else false
    end && has_permission(permission)
  end

  def manage?
    manage_group_resource(base_manage_permission)
  end

  def manage_group_resource(permission)
    # super admin
    return true if manage_all?

    (is_a_manager? || is_an_accepted_member?) && has_permission(permission)
  end

  def index?
    if group
      return true if view_group_resource(base_manage_permission)
      return true if view_group_resource(base_create_permission)

      view_group_resource(base_index_permission)
    else
      policy_group['manage_all'] ||
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

  def export_group_members_list_csv?
    user.is_group_leader_of?(group) || update?
  end

  def destroy?
    update?
  end

  def manage_comments?
    return true if user.policy_group.manage_all?
    return true if user.policy_group.manage_posts?
    return true if is_a_leader?

    record.user == user
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

    # ----------------------
    # Identifiers
    # ----------------------
    def manage_all
      'policy_groups.manage_all = true'
    end

    def is_admin_manager
      'policy_groups.groups_manage = true'
    end

    def is_a_leader
      "group_leaders.user_id = #{quote_string(user.id)}"
    end

    def is_a_manager
      "(#{is_admin_manager} OR #{is_a_leader})"
    end

    def is_a_member
      "user_groups.user_id = #{quote_string(user.id)}"
    end

    # ----------------------------
    # Permissions
    # ----------------------------
    def policy_group(permission)
      "policy_groups.#{quote_string(permission)} = TRUE"
    end

    def leader_policy(permission)
      if group_has_permission(permission)
        "group_leaders.#{quote_string(permission)} = TRUE"
      else
        'FALSE'
      end
    end

    def general_permission(permission)
      "(#{policy_group(permission)} OR #{leader_policy(permission)})"
    end

    # ------------------------------
    # Visibility Cases
    # ------------------------------
    def visibility
      if group_visibility_setting
        'CASE ' +
            "WHEN groups.#{quote_string(group_visibility_setting)} IN ('public', 'global', 'non-members') THEN TRUE " +
            "WHEN groups.#{quote_string(group_visibility_setting)} = 'group' THEN (#{is_a_manager} OR #{is_a_member}) " +
            "WHEN groups.#{quote_string(group_visibility_setting)} IN ('leaders_only', 'managers_only') THEN #{is_a_manager} " +
            'END'
      else
        'TRUE'
      end
    end

    def group_has_permission(permission)
      GroupLeader.attribute_names.include?(permission)
    end

    delegate :index?, to: :policy
    delegate :group, to: :policy
    delegate :group_visibility_setting, to: :policy

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
          .where("#{manage_all} OR (#{visibility} AND #{general_permission(permission)})")
    end

    def resolve(permission)
      if index?
        if group && group.enterprise_id == user.enterprise_id
          group_base.merge(scope.all)
        else
          non_group_base(permission)
        end
      else
        scope.none
      end
    end
  end
end
