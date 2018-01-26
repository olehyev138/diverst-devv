FactoryGirl.define do
  factory :group_leader do
    user
    group
    position_name { Faker::Company.profession }

    trait :set_email_as_group_contact do 
    	set_email_as_group_contact false
    end
  end
end
