class RewardMailerJob < ActiveJob::Base
  queue_as :mailers

  def perform(user_reward_id)
    user_reward = UserReward.find_by(id: user_reward_id)

    return if user_reward.nil?

    RewardMailer.request_to_redeem_reward(user_reward_id).deliver_later if user_reward.status.pending?
    RewardMailer.approve_reward(user_reward_id).deliver_later if user_reward.status.redeemed?
    RewardMailer.forfeit_reward(user_reward_id).deliver_later if user_reward.status.forfeited?
  end
end
