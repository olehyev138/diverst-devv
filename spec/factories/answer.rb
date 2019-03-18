FactoryBot.define do
  factory :answer do
    content { Faker::Lorem.paragraph(2) }
    question
    association :author, factory: :user
    association :contributing_group, factory: :group
    chosen false

    factory :answer_filled do
      transient do
        comment_count 2
      end

      after(:create) do |answer, evaluator|
        evaluator.comments create_list(:answer_comment, evaluator.comment_count, answer: answer)
      end
    end
  end
end
