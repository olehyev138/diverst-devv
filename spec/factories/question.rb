FactoryBot.define do
  factory :question do
    title "#{ Faker::Lorem.sentence(3) }?"
    description { Faker::Lorem.sentence }
    campaign

    factory :question_filled do
      transient do
        answer_count 2
      end

      after(:create) do |question, evaluator|
        create_list(:answer_filled, evaluator.answer_count, question: question)
      end
    end
  end
end
