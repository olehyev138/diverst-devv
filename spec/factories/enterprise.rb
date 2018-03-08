FactoryGirl.define do
  factory :enterprise do
    name { Faker::Company.name }
    created_at { Date.today }
    cdo_name {Faker::Name.name}
    theme nil
    
    after(:create) do |enterprise|
      create(:user_role, role_name: "admin",        role_type: "admin", enterprise: enterprise, priority: 0)
      create(:user_role, role_name: "group_leader", role_type: "group", enterprise: enterprise, priority: 1)
      create(:user_role, role_name: "user",         role_type: "user",  enterprise: enterprise, priority: 6, default: true)
    end
  end
end
