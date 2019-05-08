FactoryBot.define do
  factory :mentorship_availability do |f|
    f.association :user, factory: :user
    f.day { 'Monday' }
    f.start { '1:45 PM' }
    f.end { '2:35 PM' }
  end
end
