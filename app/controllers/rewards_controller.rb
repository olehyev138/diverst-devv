class RewardsController < ApplicationController
  before_action :set_enterprise
  before_action :set_reward, only: [:edit, :update, :destroy]
  after_action :verify_authorized

  layout 'global_settings'

  def index
    authorize @enterprise, :update?
    @rewards = @enterprise.rewards
    @badges = @enterprise.badges
  end

  def new
    authorize @enterprise, :update?
    @reward = Reward.new
  end

  def create
    authorize @enterprise, :update?
    @reward = @enterprise.rewards.new(reward_params)
    if @reward.save
      flash[:notice] = "Your prize was created"
      redirect_to action: :index
    else
      flash[:alert] = "Your prize was not created. Please fix the errors"
      render :new
    end
  end

  def edit
    authorize @enterprise, :update?
    @reward = @enterprise.rewards.find(params[:id])
  end

  def update
    authorize @enterprise, :update?
    if @reward.update(reward_params)
      flash[:notice] = "Your prize was updated"
      redirect_to action: :index
    else
      flash[:alert] = "Your prize was not updated. Please fix the errors"
      render :edit
    end
  end

  def destroy
    authorize @enterprise, :update?
    @reward.destroy
    flash[:notice] = "Your prize was deleted"
    redirect_to action: :index
  end

  private
  def set_enterprise
    @enterprise = current_user.enterprise
  end

  def set_reward
    @reward = @enterprise.rewards.find(params[:id])
  end

  def reward_params
    params.require(:reward).permit(:label, :points, :responsible_id, :picture, :description)
  end
end