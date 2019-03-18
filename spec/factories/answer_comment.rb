FactoryBot.define do
  factory :answer_comment do
    content { Faker::Lorem.paragraph(2) }
    answer
    association :author, factory: :user
  end
end
