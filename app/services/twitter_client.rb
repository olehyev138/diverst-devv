class TwitterClient
  Account = Struct.new(:timeline, :time_created)

  def self.account_cache
    @account_cache ||= {}
  end

  def self.tweet_cache
    @tweet_cache ||= {}
  end

  def self.get_tweets(user)
    unless account_cache.key?(user.downcase) && (Time.now - account_cache.fetch(user.downcase).time_created) / 30.minutes < 1.0
      timeline = client.user_timeline(user, exclude_replies: true)
      account_cache[user.downcase] = Account.new(timeline, Time.now)
    end
    account_cache.fetch(user.downcase).timeline
  end

  def self.get_html(id)
    unless tweet_cache.key?(id)
      html = client.oembed(id).html
      html = html.dup
      html.sub! 'twitter-tweet', 'twitter-tweet tw-align-center'
      tweet_cache[id] = html
    end
    tweet_cache.fetch(id)
  end

  def self.client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end
  end
end
