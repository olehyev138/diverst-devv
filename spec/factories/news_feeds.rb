FactoryBot.define do
  factory :news_feed do
    association :group, factory: :group
  end
end
