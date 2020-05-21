require 'rails_helper'

RSpec.describe TwitterClient, type: :service do
  def compare(actual, expected)
    mapped = actual.map { |twt| twt.text }
    comparison = mapped.zip(expected)
    comparison.each do |twt_text, number|
      expect(twt_text).to eql "Test Tweet #{number}"
    end
  end

  before do
    @test_user = 'ADiverst'
  end

  it 'Should return empty array for bad account name' do
    expect(described_class.get_tweets('')).to eql []
  end

  it 'Should return error message when getting a bad tweet ID' do
    expect(described_class.get_html(-1)).to eql '<h1>Tweet Doesn\'t Exist</h1>'
  end

  # context 'Personal Filled Account' do
  #   before(:each) do
  #     described_class.delete_tweets
  #     @numbers = []
  #     @numbers += [described_class.post_test_tweet]
  #     @numbers += [described_class.post_test_tweet]
  #     @numbers += [described_class.post_test_tweet]
  #     @numbers += [described_class.post_test_tweet]
  #     @numbers += [described_class.post_test_tweet]
  #     @numbers.reverse!
  #   end
  #
  #   scenario 'Cache Testing' do
  #     # First test if it can retrieve the tweets
  #     tweets = described_class.get_tweets(@test_user)
  #     compare(tweets, @numbers)
  #
  #     # Create a new Tweet, and check if thanks to the cache, it doesn't show on the timeline
  #     new_number = described_class.post_test_tweet
  #     tweets = described_class.get_tweets(@test_user)
  #     compare(tweets, @numbers)
  #
  #     # Clear the cache to check if it will show the new tweet in the timeline
  #     described_class.clear_cache
  #     tweets = described_class.get_tweets(@test_user)
  #     compare(tweets, [new_number] + @numbers)
  #
  #     # delete all tweets and check if the client returns an empty array of tweets
  #     described_class.delete_tweets
  #
  #     tweets = described_class.get_tweets(@test_user)
  #     expect(tweets).to eql []
  #   end
  #
  #   after(:each) do
  #     described_class.delete_tweets
  #   end
  # end
end
