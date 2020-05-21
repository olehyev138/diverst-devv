FactoryBot.define do
  factory :groups_poll do
    association :poll
    association :group
  end
end
