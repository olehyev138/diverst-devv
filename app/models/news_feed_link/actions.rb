module NewsFeedLink::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_left_joins
      [:group_message, :news_link, :social_link]
    end

    def valid_scopes
      ['approved', 'pending', 'combined_news_links', 'not_archived', 'archived']
    end
  end
end
