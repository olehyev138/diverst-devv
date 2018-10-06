FactoryGirl.define do
    factory :event_comment do
        association :user, factory: :user
        association :event, factory: :event
    end
end
