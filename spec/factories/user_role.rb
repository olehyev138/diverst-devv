FactoryBot.define do
  factory :user_role do
    enterprise
    default false
    role_name { Faker::Lorem.sentence(3) }
    role_type 'group'
    priority { Faker::Number.number(2) }
  end
end
