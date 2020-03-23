FactoryBot.define do
  factory :page_name do |f|
    f.page_name { Faker::Lorem.sentence }
  end
end
