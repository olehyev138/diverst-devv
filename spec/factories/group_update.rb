FactoryBot.define do
  factory :group_update do
    association :owner, factory: :user
    association :group
    comments { Faker::Lorem.sentence }
    data { }
    created_at { Date.today }
  end
end
