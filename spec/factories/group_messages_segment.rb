FactoryBot.define do
  factory :group_messages_segment do
    association :group_message, factory: :group_message
    association :segment, factory: :segment
  end
end
