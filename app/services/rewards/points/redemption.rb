class Rewards::Points::Redemption
  def initialize(user, reward)
    @user = user
    @reward = reward
  end

  def redeem
    reporting = Rewards::Points::Reporting.new(@user)
    if reporting.user_credits >= @reward.points
      @user_reward_id = UserReward.create(user: @user, reward: @reward, points: @reward.points, status: 0).id
      RewardMailerJob.perform_later(@user_reward_id)
      true
    else
      false
    end
  end
end
