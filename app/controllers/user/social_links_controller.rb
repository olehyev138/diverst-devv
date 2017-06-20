class User::SocialLinksController < ApplicationController
  before_action :authenticate_user!

  layout 'user'

  def index
    @posts = current_user.social_links
  end

  def new
    @social_link = current_user.social_links.new
  end

  def create
    @social_link = current_user.social_links.new(social_links_params)

    if @social_link.save
      flash[:notice] = "Your link was created"
      redirect_to action: :index
    else
      flash[:alert] = "Your link was not created. Please fix the errors"
      render :new
    end
  end

  protected

  def social_links_params
    params
      .require(:social_link)
      .permit(
        :url
      )
  end
end