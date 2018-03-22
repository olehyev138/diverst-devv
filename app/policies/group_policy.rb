class GroupPolicy < ApplicationPolicy
    def index?
        @policy_group.groups_index?
    end
    
    def new?
        manage?
    end
    
    def manage?
        @policy_group.groups_manage?
    end
    
    def show?
        index?
    end
    
    def leaders?
        return true if @policy_group.groups_manage?
        @policy_group.group_leader_manage?
    end

    def plan_overview?
        @policy_group.groups_budgets_index?
    end
    
    def calendar?
        @policy_group.global_calendar?
    end

    def close_budgets?
        @policy_group.annual_budget_manage?
    end

    def metrics?
        update?
    end

    def create?
        @policy_group.groups_create?
    end

    def update_all_sub_groups?
        create?
    end

    # move these to separate policies
    def view_all?
        create?
    end

    def add_category?
        create?
    end

    def update_with_new_category?
        create?
    end

    def update?
        return true if @policy_group.groups_manage?
        return true if @record.owner == @user

        @record.managers.include?(user)
    end
    
    def is_a_member?
       (@record.members.include? @user) || is_a_pending_member?
    end

    def is_active_member?
        @record.active_members.include? @user
    end

    def is_a_guest?
        !is_a_member?
    end

    def is_a_pending_member?
        @record.pending_members.include? @user
    end

    def view_members?
        #Ability to view members depends on settings level
        case @record.members_visibility
        when 'global'
            #Everyone can see users
            return true
        when 'group'
            #Only active group members can see other members
            is_active_member?
        when 'managers_only'
            #Only users with ability to manipulate members(admins) can see other members
            return manage_members?
        end
    end

    def view_messages?
        #Ability to view messages depends on settings level
        case @record.messages_visibility
        when 'global'
            #Everyone can see users
            return true
        when 'group'
            #Only active group messages can see other messages
            is_active_member?
        when 'managers_only'
            #Only users with ability to manipulate messages(admins) can see other memberxs
            return manage_members?
        end
    end

    def view_latest_news?
        #Ablility to view latest news depends on settings level
        case @record.latest_news_visibility
        when 'public'
            #Everyone can see latest news
            return true
        when 'group'
            #Only active group members and guests(non-members) can see latest news
            is_active_member? || is_a_guest? || is_a_pending_member?
        when 'leaders_only'
            #Only users with ability to manipulate members(admins) can see latest news
            return manage_members?
        else
            return false
        end
    end

    def view_upcoming_events?
        #Ablility to upcoming events depends on settings level
        case @record.upcoming_events_visibility
        when 'public'
            #Everyone can upcoming events
            return true
        when 'group'
            #depends on group membership
            is_active_member? || is_a_member?
        when 'leaders_only'
            #Only users with ability to manipulate members(admins) can see upcoming events
            return manage_members?
        else
            return false
        end
    end

    def view_upcoming_and_ongoing_events?
        view_upcoming_events?
    end

    def events_filter
       case @record.upcoming_events_visibility
        when 'public'
            #Everyone can upcoming events
            return true
        when 'group'
            @upcoming_events = @record.initiatives.upcoming.limit(3) + @record.participating_initiatives.upcoming.limit(3)
            # for members(who are not pending members) and when upcoming events are not empty
            return true if is_a_member? && !is_a_pending_member? && @upcoming_events
        when 'leaders_only'
            #Only users with ability to manipulate members(admins) can see upcoming events
            return manage_members?
        else
            return false
        end
    end

    def manage_members?
        @policy_group.groups_members_index?
    end

    def erg_leader_permissions?
        update? || @record.leaders.include?(@user) || parent_group_permissions?
    end

    def budgets?
        @policy_group.groups_budgets_index? || erg_leader_permissions?
    end

    def view_budget?
        @policy_group.groups_budgets_index? || erg_leader_permissions?
    end

    def request_budget?
        @policy_group.groups_budgets_request? || erg_leader_permissions?
    end

    def submit_budget?
        @policy_group.groups_budgets_request?  || erg_leader_permissions?
    end

    def approve_budget?
        @policy_group.budget_approval?
    end

    def decline_budget?
        @policy_group.budget_approval?
    end

    def parent_group_permissions?
        return false if @record.parent.nil?
        return ::GroupPolicy.new(@user, @record.parent).erg_leader_permissions?
    end

    def destroy?
        return true if @policy_group.groups_manage?
        @record.owner == @user
    end
    
    class Scope < Scope
        attr_reader :user, :scope, :permission

        def initialize(user, scope, permission)
          @user  = user
          @scope = scope
          @permission = permission
        end
    
        def resolve
            if UserRole.where(:role_name => user.role, :role_type => "group").count > 0
                scope.joins(:group_leaders).where(:group_leaders => {:user_id => user.id, permission.to_sym => true})
            else 
                scope.includes(:parent, :leaders, :owner, :initiatives)
            end
        end
    end
end
