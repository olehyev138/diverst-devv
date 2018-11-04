class GroupBasePolicy < Struct.new(:user, :context)
    
    attr_accessor :user, :group, :record
    
    def initialize(user, context)
        self.user = user
        self.group = context.first
        self.record = context.second
    end
    
    def is_a_member?
        UserGroup.where(:user_id => user.id, :group_id => group.id).exists?
    end
    
    def is_a_manager?(permission)
        return true if is_admin_manager?(permission)
        is_a_leader? &&  user.policy_group[permission]
    end
    
    def is_admin_manager?(permission)
        # super admin
        return true if user.policy_group.manage_all?
        # groups manager
        user.policy_group.groups_manage? && user.policy_group[permission]
    end
    
    def is_a_leader?
       GroupLeader.where(:user_id => user.id, :group_id => group.id).exists?
    end

    def is_active_member?
        UserGroup.where(:accepted_member => true, :user_id => user.id, :group_id => @record.id).exists?
    end

    def is_a_guest?
        !is_a_member?
    end

    def is_a_pending_member?
        UserGroup.where(:accepted_member => false, :user_id => user.id, :group_id => @record.id).exists?
    end
    
    def has_group_leader_permissions?(permission)
        return false if !is_a_leader?
        return false if !GroupLeader.attribute_names.include?(permission)
        return group.group_leaders.where(:user_id => user.id).where("#{permission} = true").exists?
    end
    
    def view_group_resource(permission)
        return true if manage_group_resource(permission)
        
        # super admin
        return true if user.policy_group.manage_all?
        # groups manager
        return true if user.policy_group.groups_manage? &&  user.policy_group[permission]
        # group leader
        return true if is_a_leader? &&  user.policy_group[permission]
        # group member
        return true if is_a_member? &&  user.policy_group[permission]
    end
    
    def manage_group_resource(permission)
        # super admin
        return true if user.policy_group.manage_all?
        # groups manager
        return true if user.policy_group.groups_manage? &&  user.policy_group[permission]
        # group leader
        return true if has_group_leader_permissions?(permission)
        # group member
        return true if is_a_member? &&  user.policy_group[permission]
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

    def archive?
      return true if user.policy_group.permissions_manage? || user.policy_group.group_resources_manage?
      false
    end

    def base_index_permission
    end
    
    def base_create_permission
    end
    
    def base_manage_permission
    end
    
end