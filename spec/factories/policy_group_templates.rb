FactoryBot.define do
  factory :policy_group_template do
    name 'Name'
    association :user_role, factory: :user_role
    enterprise
  end
end
