FactoryGirl.define do
  factory :mentorship_availability do |f|
      f.association :user, factory: :user
      f.start { Faker::Time.between(Date.today, 1.month.from_now) }
      f.end { Faker::Time.between(32.days.from_now, 2.months.from_now)}
  end
end
