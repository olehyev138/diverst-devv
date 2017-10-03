class User::SocialLinksController < ApplicationController
  before_action :authenticate_user!

  before_action :set_social_link, only: [:destroy]

  layout 'user'

  def index
    @posts = current_user.social_links.order(created_at: :desc)
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

  def destroy
    authorize @social_link

    if @social_link.destroy
      flash[:notice] = "Your social post was removed"
    else
      flash[:alert] = "An error occured while deleting your social post"
    end

    redirect_to action: :index
  end

  protected

  def social_links_params
    params
      .require(:social_link)
      .permit(
        :url
      )
  end

  def set_social_link
    @social_link = current_user.social_links.find(params[:id])
  end
end