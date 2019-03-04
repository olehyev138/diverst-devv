FactoryBot.define do
  factory :news_link_comment do
    content { Faker::Lorem.paragraph(2) }
    association :news_link
    association :author, factory: :user
  end
end
