class TwitterClient
  Account = Struct.new(:timeline, :time_created, :exists)
  # This should also be an environment variable
  MY_ACCOUNT_NAME = 'ADiverst'

  def self.account_cache
    @account_cache ||= {}
  end

  def self.tweet_cache
    @tweet_cache ||= {}
  end

  def self.this_account
    @this_name || MY_ACCOUNT_NAME
  end

  def self.get_tweets(user)
    update_account_cache(user)
    account_cache.fetch(user.downcase).timeline
  end

  def self.user_exists?(user)
    update_account_cache(user)
    account_cache.fetch(user.downcase).exists
  end

  def self.update_account_cache(user)
    if !account_cache.key?(user.downcase) || outdated?(user)
      begin
        timeline = client.user_timeline(user, exclude_replies: true)
        account_cache[user.downcase] = Account.new(timeline, Time.now, true)
      rescue
        account_cache[user.downcase] = Account.new([], Time.now, false)
      end
    end
  end

  def self.get_html(id)
    unless tweet_cache.key?(id)
      begin
        html = client.oembed(id).html
        html = html.dup
        html.sub! 'twitter-tweet', 'twitter-tweet tw-align-center'
        tweet_cache[id] = html
      rescue
        return '<h1>Tweet Doesn\'t Exist</h1>'
      end
    end
    tweet_cache.fetch(id)
  end

  def self.client
    # KEYS ARE FOR TESTING ACCOUNT. MOVE TO application.yml
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end
  end

  def self.post_test_tweet
    number = Random.rand(1000)
    client.update("Test Tweet #{number}")
    number
  end

  def self.delete_tweets
    timeline = client.user_timeline(this_account, exclude_replies: false)
    tweets_count = timeline.size
    timeline.each do |twt|
      client.destroy_tweet(twt.id)
      tweet_cache.delete(twt.id)
    end
    account_cache.delete(this_account.downcase)
    tweets_count
  end

  def self.clear_cache
    @account_cache = {}
    @tweet_cache = {}
  end

  protected

  def self.outdated?(user)
    account_cache.fetch(user.downcase).time_created < 30.minutes.ago
  end
end
