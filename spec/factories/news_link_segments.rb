FactoryBot.define do
  factory :news_link_segment do
    association :segment, factory: :segment
    association :news_link, factory: :news_link
  end
end
