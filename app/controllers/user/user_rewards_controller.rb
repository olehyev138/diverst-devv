class User::UserRewardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reward, only: [:create]
  before_action :set_user_reward, only: [:approve_reward, :forfeit_reward, :reward_to_be_forfeited]

  layout :resolve_layout

  def create
    if Rewards::Points::Redemption.new(current_user, @reward).redeem
      redirect_to action: :success
    else
      redirect_to action: :error
    end
  end

  def approve_reward
    authorize current_user.enterprise, :update?

    @user_reward.approve_reward_redemption
    RewardMailerJob.perform_later(@user_reward.id)
    flash[:notice] = "#{@user_reward.user.name}'s reward has been redeemed!"

    redirect_to :back
  end

  def reward_to_be_forfeited
    authorize current_user.enterprise, :update?

    respond_to do |format|
      format.html
      format.js
    end
  end

  def forfeit_reward
    authorize current_user.enterprise, :update?

    @user = @user_reward.user
    @user_reward.update(user_reward_params.merge({ status: 2 }))

    RewardMailerJob.perform_later(@user_reward.id)
    flash[:notice] = "#{@user.name}'s reward has been forfeited!"
    redirect_to :back
  end

  def success ; end

  def error ; end


  private

  def resolve_layout
    case action_name
    when 'create', 'success', 'error'
      'user'
    when 'approve_reward'
      'global_settings'
    end
  end

  def set_reward
    @reward = current_user.enterprise.rewards.find(params[:reward_id])
  end

  def set_user_reward
    @user_reward = UserReward.find(params[:id])
  end

  def user_reward_params
    params.require(:user_reward).permit(:comment)
  end
end
