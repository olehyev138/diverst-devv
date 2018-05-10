class ViewsController < ApplicationController
  def track
    news_feed_link = NewsFeedLink.find(params[:id])
    news_feed_link.increment_view(current_user)

    render nothing: true
  end

  private

  def views_params
    params.permit(:id)
  end
end
