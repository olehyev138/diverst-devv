class RewardActionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_enterprise
  after_action :verify_authorized

  layout 'global_settings'

  def update
    authorize @enterprise, :update?
    @rewards = @enterprise.rewards
    @badges = @enterprise.badges

    if @enterprise.update(reward_actions_params)
      flash[:notice] = 'Your reward actions were updated'
      redirect_to rewards_path
    else
      flash[:alert] = 'Your reward actions were not updated. Please fix the errors'
      render 'rewards/index'
    end
  end

  private

  def set_enterprise
    @enterprise = current_user.enterprise
  end

  def reward_actions_params
    params.require(:enterprise).permit(reward_actions_attributes: [:name, :points, :id])
  end
end
