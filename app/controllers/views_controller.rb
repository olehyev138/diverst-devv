class ViewsController < ApplicationController
  def track
    news_feed_link = NewsFeedLink.find(params[:id])
    View.increment_view(news_feed_link.link, current_user)

    render nothing: true
  end

  private

  def views_params
    params.permit(:id)
  end
end
