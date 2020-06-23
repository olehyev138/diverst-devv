FactoryBot.define do
  factory :news_feed_link_tag do
    association :news_tag, factory: :news_tag
    association :news_feed_link, factory: :news_feed_link
  end
end
