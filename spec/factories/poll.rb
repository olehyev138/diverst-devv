FactoryGirl.define do
  factory :poll do
    title 'My Poll'
    description 'This poll is awesome.'
    nb_invitations 10
    enterprise

    factory :poll_with_responses do
      transient do
        response_count 10
      end

      after(:create) do |poll, evaluator|
        evaluator.responses create_list(:poll_response, evaluator.response_count, poll: poll)
      end
    end
  end
end
