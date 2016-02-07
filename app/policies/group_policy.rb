class GroupPolicy
  def initialize(user, group)
    @user = user
    @group = group
  end

  def manage?
    @user.is_a?(Admin) || @group.managers.exists?(user.id)
  end

  def create?
    @user.is_a?(Admin)
  end

  def edit?
    return false unless @user.is_a?(Admin)
    @user.owner? || @group.admin == @user
  end
end
