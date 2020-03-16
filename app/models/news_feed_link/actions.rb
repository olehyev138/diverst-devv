module NewsFeedLink::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_left_joins
      [:group_message, :news_link, :social_link]
    end

    def valid_scopes
      ['approved', 'pending', 'combined_news_links', 'not_archived', 'archived', 'pinned', 'not_pinned']
    end

    def base_preloads
      [
          :group_message,
          :news_link,
          :social_link,
          :news_feed,
          :views,
          :likes,
          group_message: GroupMessage.base_preloads,
          news_link: NewsLink.base_preloads,
          social_link: SocialLink.base_preloads
      ]
    end
  end
end
