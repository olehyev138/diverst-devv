class User::NewsLinksController < ApplicationController
  before_action :authenticate_user!

  layout 'user'

  def index
    @news_links = current_user.news_links.includes(:author, :group).order(created_at: :desc)
  end
end
