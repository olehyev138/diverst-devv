FactoryBot.define do
  factory :topic_feedback do
    content { Faker::Lorem.paragraph }
    topic

    trait :featured do
      featured true
    end
  end
end
