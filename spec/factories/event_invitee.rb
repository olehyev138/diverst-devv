FactoryGirl.define do
    factory :event_invitee do
        association :user, factory: :user
        association :event, factory: :event
    end
end
