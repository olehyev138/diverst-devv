class Rewards::Points::Manager
  def initialize(user, action_key)
    @user = user
    @reward_action = RewardAction.where(key: action_key, enterprise: @user.enterprise).first
  end

  def add_points(entity)
    if @user && @reward_action
      add_points_to_user(entity)
      update_user_points
      update_user_credits
    end
  end

  def remove_points(entity)
    if @user && @reward_action
      remove_points_from_user(entity)
      update_user_points
      update_user_credits
    end
  end

  private
  def add_points_to_user(entity)
    UserRewardAction.create(
      user: @user,
      reward_action: @reward_action,
      points: @reward_action.points.to_i,
      operation: "add",
      entity: entity
    )
  end

  def remove_points_from_user(entity)
    last_user_reward_action_of_same_entity = UserRewardAction.where(
      entity: entity,
      operation: UserRewardAction.operations[:add]
    ).order(created_at: :desc).first

    points = last_user_reward_action_of_same_entity.try(:points) || 0

    UserRewardAction.create(
      user: @user,
      reward_action: @reward_action,
      points: points,
      operation: "del",
      entity: entity
    )
  end

  def update_user_points
    @user.update(points: user_points)
  end

  def update_user_credits
    @user.update(credits: user_credits)
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
