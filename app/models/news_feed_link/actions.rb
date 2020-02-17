module NewsFeedLink::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def valid_scopes
      ['approved', 'pending', 'combined_news_links', 'not_archived', 'archived']
    end
  end
end
