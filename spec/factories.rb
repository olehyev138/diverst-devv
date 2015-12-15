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

    factory :campaign_filled do
      transient do
        question_count 2
      end

      after(:create) do |campaign, evaluator|
        create_list(:question_filled, evaluator.question_count, campaign: campaign)
      end
    end
  end

  factory :question do
    title "My Question?"
    description "This is a question."
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

  factory :answer do
    content "This is an answer."
    question
    association :author, factory: :employee
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

  factory :answer_comment do
    content "This is a comment."
    answer
    association :author, factory: :employee
  end

  factory :answer_upvote do
    association :employee
    association :answer
  end

  factory :yammer_field_mapping do

  end

  factory :graph do
    # association :field, factory: :graph_field
    # association :aggregation, factory: :graph_field

    factory :dashboard_graph do
      association :collection, factory: :metrics_dashboard
    end

    factory :poll_graph do
      association :collection, factory: :poll
    end
  end

  factory :metrics_dashboard do
    enterprise
    name "Metrics dashboard"

    factory :metrics_dashboard_with_graphs do
      transient do
        graph_count 2
      end

      after(:create) do |metrics_dashboard, evaluator|
        evaluator.graphs create_list(:dashboard_graph, evaluator.graph_count, collection: metrics_dashboard)
      end
    end
  end

  factory :field do
    type "TextField"
    title "My Field"
    gamification_value 1
    show_on_vcard false
    saml_attribute nil

    factory :checkbox_field do
      type "CheckboxField"
      options_text "Yes\nNo"
    end

    factory :select_field do
      type "SelectField"
      options_text "Yes\nNo"
    end

    factory :numeric_field do
      type "NumericField"
      min 1
      max 100
    end

    match_exclude true
    match_polarity true
    match_weight 1

    factory :enterprise_field do
      association :container, factory: :enterprise
    end

    factory :graph_field do
      association :container, factory: :graph
    end
  end

end