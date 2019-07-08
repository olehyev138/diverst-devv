class User::UsageController < ApplicationController
  before_action :set_user

  layout 'metrics'

  def index
    @user_metrics = {
      logins: @user.get_login_count,
      posts: @user.number_of_posts,
      comments: @user.number_of_comments,
      events: @user.number_of_events
    }

    @most_visited_pages = @user.most_viewed_pages
  end

  def url_data
    print(params)
    respond_to do |format|
      format.html
      format.json { render json: UsageDatatable.new(view_context) }
    end
  end

  private

  def set_user
    @user = User.find_by_id(params[:id]) || current_user
  end
end

# logins / most visited page / time on page / # of posts / # of comments  / # of events attended / Recommend
