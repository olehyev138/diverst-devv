module NewsFeedLink::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_left_joins(diverst_request)
      [:group_message, :news_link, :social_link]
    end

    def valid_scopes
      ['approved', 'pending', 'combined_news_links', 'not_archived', 'archived', 'pinned', 'not_pinned']
    end

    def base_preloads(diverst_request)
      [
          :group_message,
          :news_link,
          :social_link,
          :news_feed,
          :views,
          :likes,
          :group,
          group_message: GroupMessage.base_preloads(diverst_request),
          news_link: NewsLink.base_preloads(diverst_request),
          social_link: SocialLink.base_preloads(diverst_request),
      ]
    end

    def order_string(order_by, order)
      "news_feed_links.is_pinned desc, #{order_by} #{order}"
    end
  end
end
