class User::UserRewardsController < ApplicationController
  before_action :authenticate_user!

  layout 'user'

  def create
    reward = current_user.enterprise.rewards.find(params[:reward_id])
    if Rewards::Points::Redemption.new(current_user, reward).redeem
      redirect_to action: :success
    else
      redirect_to action: :error
    end
  end

  def success ; end

  def error ; end
end
