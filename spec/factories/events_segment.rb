FactoryGirl.define do
    factory :events_segment do
        association :segment, factory: :segment
        association :event, factory: :event
    end
end
