class RewardsController < ApplicationController
  before_action :set_enterprise
  after_action :verify_authorized

  layout 'global_settings'

  def edit
    authorize @enterprise, :update?
  end

  def update_reward_actions
    authorize @enterprise, :update?
    if @enterprise.update(reward_actions_params)
      flash[:notice] = "Your reward actions were updated"
      redirect_to :back
    else
      flash[:notice] = "Your reward actions were not updated. Please fix the errors"
      render :edit
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
