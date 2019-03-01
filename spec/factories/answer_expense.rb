FactoryBot.define do
  factory :answer_expense do
    association :answer
    association :expense
  end
end
