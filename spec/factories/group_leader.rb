FactoryGirl.define do
  factory :group_leader do
    user {create(:user)}
    group { create(:group, :enterprise => user.enterprise)}
    position_name { Faker::Company.profession }
    user_role {group.enterprise.user_roles.where(:role_name => "group_leader").first}
    trait :default_group_contact do 
    	default_group_contact false
    end
  end
end
