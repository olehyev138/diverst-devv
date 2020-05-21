FactoryBot.define do
  factory :users_segment do
    association :user
    association :segment
  end
end
