FactoryGirl.define do
  factory :news_feed_link do
    association :news_feed, factory: :news_feed
    association :link, factory: :news_link
    views { |view| [ view.association(:view) ] }
  end
end
