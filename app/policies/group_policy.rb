class GroupPolicy < ApplicationPolicy
  def index?
    @policy_group.groups_index?
  end

  def create?
    @policy_group.groups_create?
  end

  def update?
    return true if @policy_group.groups_manage?
    return true if @record.owner == @user
    @record.managers.exists?(user.id)
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
      #Only users with ability to manipulate members(admins) can see other memberxs
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

  def manage_members?
    return true if @policy_group.groups_manage?
    return true if @record.owner == @user
    @record.managers.exists?(user.id)
  end

  def budgets?
    @policy_group.groups_budgets_index? || @record.leaders.include?(@user)
  end

  def view_budget?
    @policy_group.groups_budgets_index? || @record.leaders.include?(@user)
  end

  def request_budget?
    @policy_group.groups_budgets_request?
  end

  def submit_budget?
    @policy_group.groups_budgets_request?
  end

  def approve_budget?
    @policy_group.budget_approval?
  end

  def decline_budget?
    @policy_group.budget_approval?
  end

  def destroy?
    return true if @policy_group.groups_manage?
    @record.owner == @user
  end
end
