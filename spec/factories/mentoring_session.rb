FactoryGirl.define do
  factory :mentoring_session do |f|
    f.start { Faker::Time.between(Date.today, 1.month.from_now) }
    f.end { Faker::Time.between(32.days.from_now, 2.months.from_now)}
    f.status { ["scheduled", "completed", "canceled"].sample }
    f.notes { Faker::Lorem.sentence }
    f.format {["in_person", "webx", "zoom", "video"].sample}
  end
end
