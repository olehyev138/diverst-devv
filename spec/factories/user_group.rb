FactoryGirl.define do
  factory :user_group do
    association :user
    association :group

    accepted_member { true }
  end
end