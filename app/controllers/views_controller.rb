class ViewsController < ApplicationController
  def track
    # In order to keep this generic we are passed the news_feed_link id
    # We then look it up and get its 'link' association which is the concrete news feed object
    news_feed_link = NewsFeedLink.find(params[:id])
    View.increment_view(news_feed_link.link, current_user)

    render nothing: true
  end

  private

  def views_params
    params.permit(:id)
  end
end
