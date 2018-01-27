FactoryGirl.define do
  factory :group_leader do
    user
    group
    position_name { Faker::Company.profession }

    trait :group_contact do 
    	group_contact false
    end
  end
end
