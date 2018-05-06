class View < ActiveRecord::Base
  belongs_to :news_feed_link

  class << self
    def total_views
      View.sum(:view_count)
    end

    def unique_views
      View.all.count
    end

    def increment_view(news_object, user)
      view = news_object.views.find_or_create_by(user_id: user.id)
      view.view_count += 1
      view.save
    end
  end
end
