FactoryGirl.define do
  factory :event do
    title 'Incredible event'
    description 'This event is going to be awesome!'
    location 'Montreal'
    max_attendees 15

    association :group, factory: :group_with_users
  end
end
