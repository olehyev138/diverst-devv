FactoryBot.define do
  factory :initiative_comment do
    content { Faker::Lorem.paragraph(2) }
    association :initiative
    association :user

    trait :approved do
      approved false
    end
  end
end
