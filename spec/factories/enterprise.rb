FactoryGirl.define do
  factory :enterprise do
    name { Faker::Company.name }
    created_at { Date.today }
    cdo_name {Faker::Name.name}
    theme nil
    
    after(:create) do |enterprise|
      create(:user_role, role_name: "user",        role_type: "user", enterprise: enterprise)
      create(:user_role, role_name: "group_leader", role_type: "group", enterprise: enterprise)
    end
  end
end
