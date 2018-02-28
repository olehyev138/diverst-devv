FactoryGirl.define do
  factory :user_role do
    association :enterprise, factory: :enterprise
    default false
    name "admin"
    role_type "user"
  end
end
