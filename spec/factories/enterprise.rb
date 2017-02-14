FactoryGirl.define do
  factory :enterprise do
    name { Faker::Company.name }
    created_at { Time.current }

    theme nil
  end
end
