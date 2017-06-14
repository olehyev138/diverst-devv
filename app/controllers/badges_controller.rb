class BadgesController < ApplicationController
  before_action :set_enterprise
  before_action :set_badge, only: [:edit, :update, :destroy]
  after_action :verify_authorized

  layout 'global_settings'

  def new
    authorize @enterprise, :update?
    @badge = Badge.new
  end

  def create
    authorize @enterprise, :update?
    @badge = @enterprise.badges.new(badge_params)
    if @badge.save
      flash[:notice] = "Your #{ c_t(:badge) } was created"
      redirect_to rewards_path
    else
      flash[:alert] = "Your #{ c_t(:badge) } was not created. Please fix the errors"
      render :new
    end
  end

  def edit
    authorize @enterprise, :update?
    @badge = @enterprise.badges.find(params[:id])
  end

  def update
    authorize @enterprise, :update?
    if @badge.update(badge_params)
      flash[:notice] = "Your #{ c_t(:badge) } was updated"
      redirect_to rewards_path
    else
      flash[:alert] = "Your #{ c_t(:badge) } was not updated. Please fix the errors"
      render :edit
    end
  end

  def destroy
    authorize @enterprise, :update?
    @badge.destroy
    flash[:notice] = "Your #{ c_t(:badge) } was deleted"
    redirect_to rewards_path
  end

  private
  def set_enterprise
    @enterprise = current_user.enterprise
  end

  def set_badge
    @badge = @enterprise.badges.find(params[:id])
  end

  def badge_params
    params.require(:badge).permit(:label, :points, :image)
  end
end
