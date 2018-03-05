FactoryGirl.define do
  factory :user_role do
    enterprise
    default false
    role_name "admin"
    role_type "user"
  end
end
