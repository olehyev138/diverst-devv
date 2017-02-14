FactoryGirl.define do
  factory :group_message do
    subject { Faker::Lorem.sentence(3) }
    content { Faker::Lorem.sentence }

    association :group, factory: :group_with_users
    association :owner, factory: :user
  end
end
