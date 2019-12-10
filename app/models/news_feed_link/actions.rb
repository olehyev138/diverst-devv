module NewsFeedLink::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def valid_scopes
      ['approved', 'not_approved', 'combined_news_links']
    end
  end
end
