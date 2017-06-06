module Rewardable
  extend ActiveSupport::Concern

  def user_rewarder(action_key)
    Rewards::Points::Manager.new(current_user, action_key)
  end

  def flash_reward(message)
    if ENV['REWARDS_ENABLED']
      flash[:reward] = message
    end
  end
end
