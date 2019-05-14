class Rewards::Points::Manager
  def initialize(user, action_key)
    @user = user
    @reward_action = RewardAction.where(key: action_key, enterprise: @user.enterprise).first
    @reporting = Rewards::Points::Reporting.new(@user)
  end

  def add_points(entity)
    if @user && @reward_action
      add_points_to_user(entity)
      add_points_to_weekly_cache(entity)
      update_user_points
    end
  end

  def remove_points(entity)
    if @user && @reward_action
      remove_points_from_user(entity)
      remove_points_from_weekly_cache(entity)
      update_user_points
    end
  end

  private

  def add_points_to_user(entity)
    entity.user_reward_actions.create(
      user: @user,
      reward_action: @reward_action,
      points: @reward_action.points.to_i,
      operation: 'add'
    )
  end

  def remove_points_from_user(entity)
    last_user_reward_action_of_same_entity = entity.user_reward_actions.where(
      user: @user,
      reward_action: @reward_action,
      operation: UserRewardAction.operations[:add],
    ).order(created_at: :desc).first

    points = last_user_reward_action_of_same_entity.try(:points)

    entity.user_reward_actions.create(
      user: @user,
      reward_action: @reward_action,
      points: points.to_i,
      operation: 'del'
    )
  end

  def update_user_points
    @user.update(points: @reporting.user_points, credits: @reporting.user_credits)
  end

  def add_points_to_weekly_cache(entity)
    add_weekly_points(@user)
    group = entity.try(:group)
    add_weekly_points(group) if group
    user_group = UserGroup.find_by(user: @user, group: group)
    add_weekly_points(user_group) if user_group
  end

  def remove_points_from_weekly_cache(entity)
    remove_weekly_points(@user)
    group = entity.try(:group)
    remove_weekly_points(group) if group
    user_group = UserGroup.find_by(user: @user, group: group)
    remove_weekly_points(user_group) if user_group
  end

  def add_weekly_points(obj)
    obj.update(total_weekly_points: obj.total_weekly_points + @reward_action.points.to_i)
  end

  def remove_weekly_points(obj)
    points = obj.total_weekly_points - @reward_action.points.to_i
    points = points > 0 ? points : 0
    obj.update(total_weekly_points: points)
  end
end
