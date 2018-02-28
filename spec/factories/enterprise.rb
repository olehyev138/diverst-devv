FactoryGirl.define do
  factory :enterprise do
    name { Faker::Company.name }
    created_at { Date.today }
    cdo_name {Faker::Name.name}
    theme nil
    
    after(:create) do |enterprise|
      FactoryGirl.create_list(:user_role, 1, enterprise: enterprise)
    end
  end
end
