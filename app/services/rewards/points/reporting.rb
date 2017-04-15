class Rewards::Points::Reporting
  def initialize(user)
    @user = user
  end

  def user_points
    earned_points = UserRewardAction.where(
      user: @user,
      operation: UserRewardAction.operations[:add]
    ).sum(:points)

    removed_points = UserRewardAction.where(
      user: @user,
      operation: UserRewardAction.operations[:del]
    ).sum(:points)

    @user_points ||= earned_points - removed_points
  end

  def user_credits
    user_points - UserReward.where(user: @user).sum(:points)
  end
end
