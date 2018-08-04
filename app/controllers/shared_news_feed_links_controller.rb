class SharedNewsFeedLinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    shared_news_feed_link = SharedNewsFeedLink.find(params[:id])
    shared_news_feed_link.destroy
    redirect_to :back
  end
end
