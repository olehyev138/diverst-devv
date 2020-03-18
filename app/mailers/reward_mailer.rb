class RewardMailer < ApplicationMailer
  def request_to_redeem_reward(user_reward_id)
    return if user_reward_id.nil?

    user_reward = UserReward.find_by(id: user_reward_id)
    @user = user_reward.user
    @reward = user_reward.reward
    @email = @reward.responsible.email_for_notification
    return if @user.enterprise.disable_emails?

    set_defaults(@user.enterprise, method_name)

    mail(from: @from_address, to: @email, subject: 'A request for reward redemption')
  end

  def approve_reward(user_reward_id)
    return if user_reward_id.nil?

    user_reward = UserReward.find_by(id: user_reward_id)
    @user = user_reward.user
    @reward = user_reward.reward
    @email = @user.email_for_notification
    return if @user.enterprise.disable_emails?

    set_defaults(@user.enterprise, method_name)

    mail(from: @from_address, to: @email, subject: 'Reward Approval')
  end

  def forfeit_reward(user_reward_id)
    return if user_reward_id.nil?

    user_reward = UserReward.find_by(id: user_reward_id)
    @user = user_reward.user
    @reward = user_reward.reward
    @email = @user.email_for_notification
    @comment = user_reward.comment
    return if @user.enterprise.disable_emails?

    set_defaults(@user.enterprise, method_name)

    mail(from: @from_address, to: @email, subject: 'Reward Request Denied')
  end
end
