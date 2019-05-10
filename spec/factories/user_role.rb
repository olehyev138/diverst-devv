FactoryBot.define do
  factory :user_role do
    enterprise
    default false
    role_name 'group_treasurer'
    role_type 'group'
    priority 99
  end
end
