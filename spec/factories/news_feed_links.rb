FactoryBot.define do
  factory :news_feed_link do
    association :news_feed, factory: :news_feed
    association :news_link, factory: :news_link
  end
end
