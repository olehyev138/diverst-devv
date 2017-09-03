FactoryGirl.define do
  factory :bias do
    association :user, factory: :user
    description {Faker::Lorem.paragraph(2)}
    severity {1}
  end
end
