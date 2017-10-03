FactoryGirl.define do
  factory :initiative_comment do
    content { Faker::Lorem.paragraph(2) }
    association :initiative
    association :user
  end
end