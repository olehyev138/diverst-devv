FactoryBot.define do
  factory :news_link do
    title 'New link'
    description { Faker::Lorem.sentence(3) }
    url { Faker::Internet.url }
    association :author, factory: :user
    association :group, factory: :group_with_users
  end
end
