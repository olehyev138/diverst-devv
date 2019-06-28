FactoryBot.define do
  factory :initiative_user do
    association :initiative
    association :user
    attended false
    check_in_time nil
  end
end
