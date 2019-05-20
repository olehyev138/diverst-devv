class TwitterClient
  Account = Struct.new(:timeline, :time_created, :exists)
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
    if !account_cache.key?(user.downcase) || (Time.now - account_cache.fetch(user.downcase).time_created) < 30.minutes
      begin
        timeline = client.user_timeline(user, exclude_replies: true)
        account_cache[user.downcase] = Account.new(timeline, Time.now, true)
      rescue
        account_cache[user.downcase] = Account.new([], Time.now, false)
      end
    end
    account_cache.fetch(user.downcase).timeline
  end

  def self.get_html(id)
    unless tweet_cache.key?(id)
      begin
        html = client.oembed(id).html
        html = html.dup
        html.sub! 'twitter-tweet', 'twitter-tweet tw-align-center'
        tweet_cache[id] = html
      rescue
        return '<h1>**S</h1>'
      end
    end
    tweet_cache.fetch(id)
  end

  def self.client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY'] || 'pL0LFoicmzqhb1OH5pyHTx2jB'
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET'] || 'ocN6m4LuELmtgw9kISvUZ4365RDdfz0HVBRdEid74VHa40PTWz'
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN'] || '1126509815176495104-33357yN0yeoCbw2sSUJI08QcC2VqFT'
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET'] || 'hEabjYDCs6mOiRAsYOY9ixDsyGPNc7qfg01jkLU3VOjb2'
    end
  end

  def self.post_test_tweet
    number = Random.rand(1000)
    client.update("Test Tweet #{number}")
    number
  end

  def self.delete_tweets
    client.user_timeline(this_account, exclude_replies: false).each do |twt|
      client.destroy_tweet(twt.id)
      tweet_cache.delete(twt.id)
    end
    account_cache.delete(this_account.downcase)
  end

  def self.clear_cache
    @account_cache = {}
    @tweet_cache = {}
  end

  def self.user_exists?(user_name)
    unless account_cache.key?(user_name.downcase)
      begin
        timeline = client.user_timeline(user_name, exclude_replies: true)
        account_cache[user_name.downcase] = Account.new(timeline, Time.now, true)
      rescue Twitter::Error::Unauthorized, Twitter::Error::NotFound
        account_cache[user_name.downcase] = Account.new([], Time.now, false)
      end
    end
    account_cache.fetch(user_name.downcase).exists
  end
end
