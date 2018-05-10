FactoryGirl.define do
  factory :view do
    user_id { Faker::Number.between(1, 1000) }
    news_feed_link_id { Faker::Number.between(1, 1000) }
    view_count { Faker::Number.between(1, 1000)}
  end
end
