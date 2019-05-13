FactoryBot.define do
  factory :user_group do
    association :user
    association :group
    data nil

    accepted_member { true }
  end
end
