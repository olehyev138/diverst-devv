class GroupPolicy < ApplicationPolicy
    
    def index?
        return true if @policy_group.manage_all?
        @policy_group.groups_index?
    end
    
    def new?
        create?
    end
    
    def show?
        index?
    end

    def create?
        return true if @policy_group.manage_all?
        @policy_group.groups_create?
    end
    
    def manage_all_groups?
        #return true if parent_group_permissions?
        # super admin
        return true if @policy_group.manage_all?
        # groups manager
        return true if @policy_group.groups_manage? &&  @policy_group.group_settings_manage?
    end
    
    def manage_all_group_budgets?
        #return true if parent_group_permissions?
        # super admin
        return true if @policy_group.manage_all?
        # groups manager
        return true if @policy_group.groups_manage? &&  @policy_group.groups_budgets_manage?
    end
    
    def manage?
        return true if manage_all_groups?
        # group leader
        return true if has_group_leader_permissions?("group_settings_manage")
        # group member
        return true if is_a_member? &&  @policy_group.group_settings_manage?
    end
    
    def is_a_pending_member?
        @record.pending_members.include? user
    end

    def view_members?
        #Ability to view members depends on settings level
        case @record.members_visibility
        when 'global'
            #Everyone can see users
            return true
        when 'group'
            #Only active group members can see other members
            is_active_member? || manage_members?
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
            is_active_member? || manage_members?
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
            is_active_member? || is_a_guest? || is_a_pending_member? || manage_members?
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
            is_active_member? || is_a_member? || manage_members?
        when 'leaders_only'
            #Only users with ability to manipulate members(admins) can see upcoming events
            return manage_members?
        when 'non_member'
            # non members of a group who have access to view events
            is_a_guest? && @policy_group.initiatives_index?
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
            return true if is_a_member? && !is_a_pending_member? && @upcoming_events || manage_members?
        when 'leaders_only'
            #Only users with ability to manipulate members(admins) can see upcoming events
            return manage_members?
        else
            return false
        end
    end

    def manage_members?
        @policy_group.groups_members_manage?
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
    
    def is_a_member?
       (@record.members.include? user) || is_a_pending_member?
    end
    
    def is_a_leader?
       @record.leaders.include? user
    end
    
    def has_group_leader_permissions?(permission)
        return false if !is_a_leader?
        return @record.group_leaders.where(:user_id => @user.id).where("#{permission} = true").exists?
    end

    def update?
        return true if manage?
        @record.owner == @user
    end

    def parent_group_permissions?
        return false if @record.parent.nil?
        return ::GroupPolicy.new(@user, @record.parent).manage?
    end

    def destroy?
        update?
    end
    
    def calendar?
        @policy_group.global_calendar?
    end
    
    def insights?
        return true if parent_group_permissions?
        # super admin
        return true if @policy_group.manage_all?
        # groups manager
        return true if @policy_group.groups_manage? &&  @policy_group.groups_insights_manage?
        # group leader
        return true if has_group_leader_permissions?("groups_insights_manage")
        # group member
        return true if is_a_member? &&  @policy_group.groups_insights_manage?
    end
    
    def layouts?
        return true if parent_group_permissions?
        # super admin
        return true if @policy_group.manage_all?
        # groups manager
        return true if @policy_group.groups_manage? &&  @policy_group.groups_layouts_manage?
        # group leader
        return true if has_group_leader_permissions?("groups_layouts_manage")
        # group member
        return true if is_a_member? &&  @policy_group.groups_layouts_manage?
    end
    
    class Scope < Scope
        def index?
            GroupPolicy.new(user, nil).index?
        end
    
        def resolve
            if index?
                scope.where(:enterprise_id => user.enterprise_id).all
            else 
                []
            end
        end
    end
end
