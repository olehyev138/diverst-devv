class GroupPolicy
  def initialize(user, group)
    @user = user
    @group = group
  end

  def manage_members?
    @group.managers.exists?(user.id)
  end

  def create?
    @group.managers.exists?(user.id)
  end

  def edit?
    @group.managers.exists?(user.id)
  end
end
