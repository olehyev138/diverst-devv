FactoryBot.define do
  factory :group_message_comment do
    content { Faker::Lorem.sentence }
    association :message, factory: :group_message
    association :author, factory: :user
  end
end
