class User::SocialLinksController < ApplicationController
  before_action :authenticate_user!

  layout 'user'

  def index
    @posts = current_user.social_network_posts
  end
end
