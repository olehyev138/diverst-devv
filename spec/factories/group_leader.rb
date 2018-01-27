FactoryGirl.define do
  factory :group_leader do
    user
    group
    position_name { Faker::Company.profession }
  end
end
