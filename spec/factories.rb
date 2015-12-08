FactoryGirl.define do

  sequence :email do |n|
    "user#{n}@diverst.com"
  end

  factory :enterprise do
    name 'Hyperion'
    created_at { Time.now }
  end

  factory :employee do
    email
    first_name "Frank"
    last_name "Marineau"
    password 'f4k3p455w0rd'
    invitation_created_at Time.now
    invitation_sent_at Time.now
    invitation_accepted_at Time.now
    enterprise
  end

  factory :admin do
    email
    password 'f4k3p455w0rd'
    enterprise
  end

  factory :employee_group do
    association :employee
    association :group
  end

  factory :group do
    name 'LGBT'
    enterprise

    factory :group_with_employees do
      transient do
        employees_count 100
      end

      after(:create) do |group, evaluator|
        create_list(:employee_group, evaluator.employees_count, group: group)
      end
    end
  end

  factory :event do
    title "Incredible event"
    description "This event is going to be awesome!"
    location "Montreal"
    max_attendees 15
    association :group, factory: :group_with_employees
  end

  factory :resource do
    title "My Resource"
    # associaion :container, factory: :enterprise
    file_file_name { 'test.pdf' }
    file_content_type { 'application/pdf' }
    file_file_size { 1024 }
  end

  factory :poll do
    title "My Poll"
    description "This poll is awesome."
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

  factory :poll_response do
    poll
    employee
  end

  factory :campaign do
    title "My Campaign"
    description "Awesome description"
    enterprise
    start DateTime.new(2015, 11, 10)
    self.end DateTime.new(2015, 11, 13) # We specify self here since end is a reserved keyword

    factory :campaign_with_questions do
      transient do
        question_count 10
      end

      after(:create) do |campaign, evaluator|
        create_list(:question_with_answers, evaluator.question_count, campaign: campaign)
      end
    end
  end

  factory :question do
    title "My Question?"
    description "This is a question."
    campaign

    factory :question_with_answers do
      transient do
        answer_count 10
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answer_count, question: question)
      end
    end
  end

  factory :answer do
    content "This is an answer."
    question
    association :author, factory: :employee
    chosen false
  end

  factory :answer_comment do
    content "This is a comment."
    answer
    association :author, factory: :employee
  end

  factory :answer_upvote do
    association :employee
    association :answer
  end

end