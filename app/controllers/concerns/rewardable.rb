module Rewardable
  extend ActiveSupport::Concern

  def user_rewarder(action_key)
    Rewards::Points::Manager.new(current_user, action_key)
  end

  def flash_reward(message)
    flash[:reward] = message if current_user.enterprise.enable_rewards?
  end
end
