FactoryGirl.define do
  factory :answer do
    content 'This is an answer.'
    question
    association :author, factory: :user
    chosen false

    trait :upvoted_2_times do
      after(:create) do |answer, evaluator|
        evaluator.votes create_list(:answer_upvote, 2, answer: answer)
      end
    end

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
