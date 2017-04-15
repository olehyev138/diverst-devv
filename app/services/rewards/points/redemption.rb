class Rewards::Points::Redemption
  def initialize(user, reward)
    @user = user
    @reward = reward
  end

  def redeem
    reporting = Rewards::Points::Reporting.new(@user)
    if reporting.user_credits >= @reward.points
      UserReward.create(user: @user, reward: @reward, points: @reward.points)
      RewardMailer.redeem_reward(@reward.responsible, @user, @reward).deliver_later
      @user.update(credits: reporting.user_credits)
      true
    else
      false
    end
  end
end
