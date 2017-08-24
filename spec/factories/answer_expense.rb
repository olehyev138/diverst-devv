FactoryGirl.define do
  factory :answer_expense do
    association :expense
    association :answer
  end
end
