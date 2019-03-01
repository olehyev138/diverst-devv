FactoryBot.define do
  factory :answer_upvote do
    association :user
    association :answer
  end
end
