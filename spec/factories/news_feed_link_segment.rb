FactoryGirl.define do
    factory :news_feed_link_segment do
        association :segment, factory: :segment
        association :news_feed_link, factory: :news_feed_link
        association :link_segment, factory: :news_link_segment
    end
end
