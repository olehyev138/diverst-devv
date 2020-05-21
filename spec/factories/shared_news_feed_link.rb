FactoryBot.define do
  factory :shared_news_feed_link do
    association :news_feed, factory: :news_feed
    association :news_feed_link, factory: :news_feed_link
  end
end
