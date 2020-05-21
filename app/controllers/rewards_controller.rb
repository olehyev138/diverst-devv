class RewardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_enterprise
  before_action :set_reward, only: [:edit, :update, :destroy]
  after_action :verify_authorized
  after_action :visit_page, only: [:index, :new, :edit]

  layout 'global_settings'

  def index
    authorize Reward
    @rewards = @enterprise.rewards
    @badges = @enterprise.badges
  end

  def new
    authorize Reward
    @reward = Reward.new
  end

  def create
    authorize Reward
    @reward = @enterprise.rewards.new(reward_params)
    if @reward.save
      flash[:notice] = 'Your reward was created'
      track_activity(@reward, :create)
      redirect_to action: :index
    else
      flash[:alert] = 'Your reward was not created. Please fix the errors'
      render :new
    end
  end

  def edit
    authorize Reward
    @reward = @enterprise.rewards.find(params[:id])
  end

  def update
    authorize Reward
    if @reward.update(reward_params)
      flash[:notice] = 'Your reward was updated'
      redirect_to action: :index
    else
      flash[:alert] = 'Your reward was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize Reward
    @reward.destroy
    flash[:notice] = 'Your reward was deleted'
    redirect_to action: :index
  end

  def enable
    authorize Reward, :manage?
    @enterprise.update_attributes(enable_rewards: params[:enterprise][:enable_rewards])
    track_activity(@enterprise, :update_rewards)
    redirect_to :back
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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Rewards'
    when 'new'
      'Reward Creation'
    when 'edit'
      "Reward Edit: #{@reward.label}"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
