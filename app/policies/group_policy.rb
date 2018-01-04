class GroupPolicy < ApplicationPolicy
    def index?
        @policy_group.groups_index?
    end

    def plan_overview?
        return true if index?

        @user.erg_leader?
    end
    
    def close_budgets?
        return true if index?

        @user.erg_leader?
    end

    def metrics?
        update?
    end

    def create?
        @policy_group.groups_create?
    end

    def update?
        return true if @policy_group.groups_manage?
        return true if @record.owner == @user

        @record.managers.include?(user)
    end

    def view_members?
        #Ability to view members depends on settings level
        case @record.members_visibility
        when 'global'
            #Everyone can see users
            return true
        when 'group'
            #Only active group members can see other members
            @record.active_members.exists? @user
        when 'managers_only'
            #Only users with ability to manipulate members(admins) can see other members
            return manage_members?
        else
            #At this point we know that something went wrong, but lets just deny access
            return false
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
            @record.active_members.exists? @user
        when 'managers_only'
            #Only users with ability to manipulate messages(admins) can see other memberxs
            return manage_members?
        else
            #At this point we know that something went wrong, but lets just deny access
            return false
        end
    end

    def view_latest_news?
        #Ablility to view latest news depends on settings level
        case @record.latest_news_visibility
        when 'public'
            #Everyone can see latest news
            return true 
        when 'group'
            #Only active group members can see other members
            @record.active_members.exists? @user
        when 'leaders_only'
            #Only users with ability to manipulate members(admins) can see other memberxs
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
            #Only active group members can see other members
            @record.active_members.exists? @user
        when 'leaders_only'
            #Only users with ability to manipulate members(admins) can see other memberxs
            return manage_members?
        else
            return false 
        end
    end


    def manage_members?
        update?
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
end
