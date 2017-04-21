class Rewards::Points::Manager
  def initialize(user, action_key)
    @user = user
    @reward_action = RewardAction.where(key: action_key, enterprise: @user.enterprise).first
    @reporting = Rewards::Points::Reporting.new(@user)
  end

  def add_points(entity)
    if @user && @reward_action
      add_points_to_user(entity)
      update_points
    end
  end

  def remove_points(entity)
    if @user && @reward_action
      remove_points_from_user(entity)
      update_points
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
      user: @user,
      reward_action: @reward_action,
      operation: UserRewardAction.operations[:add],
      entity: entity
    ).order(created_at: :desc).first

    points = last_user_reward_action_of_same_entity.try(:points)

    UserRewardAction.create(
      user: @user,
      reward_action: @reward_action,
      points: points.to_i,
      operation: "del",
      entity: entity
    )
  end

  def update_points
    @user.update(points: @reporting.user_points)
    @user.update(credits: @reporting.user_credits)
  end
end
