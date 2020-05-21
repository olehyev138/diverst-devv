FactoryBot.define do
  factory :mentoring do
    association :mentee, factory: :user
    association :mentor, factory: :user
  end
end
