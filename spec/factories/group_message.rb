FactoryBot.define do
  factory :group_message do
    subject 'Group message subject'
    content { Faker::Lorem.sentence }

    association :group, factory: :group_with_users
    association :owner, factory: :user
  end
end
