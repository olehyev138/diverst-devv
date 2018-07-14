FactoryGirl.define do
  factory :news_feed_link do
    association :link, factory: :news_link
    views { |view| [ view.association(:view) ] }
  end
end
