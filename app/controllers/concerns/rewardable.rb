module Rewardable
  extend ActiveSupport::Concern

  def return_current_user_if_defined
    return current_user if defined?(current_user)
  end

  def user_rewarder(user = nil, action_key)
    user = return_current_user_if_defined if user.nil?
    return if user.nil? # if user is still nil, return here

    Rewards::Points::Manager.new(user, action_key)
  end

  def flash_reward(message)
    flash[:reward] = message if current_user.enterprise.enable_rewards?
  end
end
