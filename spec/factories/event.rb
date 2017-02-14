FactoryGirl.define do
  factory :event do
    title { Faker::Lorem.sentence(3) }
    description { Faker::Lorem.sentence }
    location { Faker::Address.city }
    max_attendees 15

    association :group, factory: :group_with_users
  end
end
