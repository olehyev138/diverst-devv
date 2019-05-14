FactoryBot.define do
  factory :social_link_segment do
    association :segment, factory: :segment
    association :social_link, factory: :social_link
  end
end
