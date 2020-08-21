class SuggestedHirePolicy < GroupBasePolicy
  # allow suggested hire policy to show permissions with GroupMemberPolicy for now
  def base_index_permission
    'groups_members_index'
  end

  def base_create_permission
    'groups_members_manage'
  end

  def base_manage_permission
    'groups_members_manage'
  end

  def index?
    return true if group.suggested_hires.any? && super
  end

  def create?
    return true if user === user

    super
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
