class OnboardingController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:index]

  def index
    redirect_to user_root_path if @user.seen_onboarding
  end

  private

  def set_user
    @user = current_user
  end
end
