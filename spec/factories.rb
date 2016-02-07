FactoryGirl.define do
  sequence :email_address do |n|
    "user#{n}@diverst.com"
  end

  sequence :hex_color do
    '#' + '%06x' % (rand * 0xffffff)
  end

  factory :enterprise do
    name 'Hyperion'
    created_at { Time.current }

    theme nil
  end

  factory :user do
    email { generate(:email_address) }
    first_name 'Frank'
    last_name 'Marineau'
    password 'f4k3p455w0rd'
    invitation_created_at Time.current
    invitation_sent_at Time.current
    invitation_accepted_at Time.current
    enterprise
  end

  factory :admin do
    email { generate(:email_address) }
    password 'f4k3p455w0rd'
    owner true
    enterprise
  end

  factory :user_group do
    association :user
    association :group
  end

  factory :group do
    name 'LGBT'
    enterprise

    factory :group_with_users do
      transient do
        users_count 100
      end

      after(:create) do |group, evaluator|
        create_list(:user_group, evaluator.users_count, group: group)
      end
    end
  end

  factory :segment do
    name "Incredible segment"
    enterprise

    factory :segment_with_users do
      transient do
        users_count 100
      end

      after(:create) do |segment, evaluator|
        evaluator.members create_list(:user, evaluator.users_count, segments: [segment])
      end
    end
  end

  factory :event do
    title 'Incredible event'
    description 'This event is going to be awesome!'
    location 'Montreal'
    max_attendees 15

    association :group, factory: :group_with_users
  end

  factory :group_message do
    subject 'Subject of an awesome message'
    content 'This is the coolest message content I\'ve seen in a while!'

    association :group, factory: :group_with_users
  end

  factory :news_link do
    title 'Awesome news article'
    description 'This is the best news article out there!'
    url 'http://google.com'

    association :group, factory: :group_with_users
  end

  factory :resource do
    title 'My Resource'
    file_file_name { 'test.pdf' }
    file_content_type { 'application/pdf' }
    file_file_size { 1024 }
  end

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

  factory :poll_response do
    poll
    user
  end

  factory :campaign do
    title 'My Campaign'
    description 'Awesome description'
    enterprise
    start Time.zone.local(2015, 11, 10)
    self.end Time.zone.local(2015, 11, 13) # We specify self here since end is a reserved keyword

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
    title 'My Question?'
    description 'This is a question.'
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

  factory :answer_comment do
    content 'This is a comment.'
    answer
    association :author, factory: :user
  end

  factory :answer_upvote do
    association :user
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
    name 'Metrics dashboard'

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
    type 'TextField'
    title 'My Field'
    gamification_value 1
    show_on_vcard false
    saml_attribute nil

    factory :checkbox_field do
      type 'CheckboxField'
      options_text "Yes\nNo"
    end

    factory :select_field do
      type 'SelectField'
      options_text "Yes\nNo"
    end

    factory :numeric_field do
      type 'NumericField'
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

  factory :email do
    name 'Awesome Email'
    slug 'awesome-email'
    use_custom_templates true
    custom_html_template '<strong>Hey there</strong>'
    custom_txt_template 'Hey there'

    enterprise

    factory :email_with_variables do
      transient do
        variable_count 5
      end

      after(:create) do |email, evaluator|
        evaluator.variables create_list(:email_variable, evaluator.variable_count, email: email)
      end
    end
  end

  factory :email_variable do
    email
    key 'mysterious-variable'
    description 'This is a mysterious variable!'
    required false
  end

  factory :theme do
    primary_color { generate(:hex_color) }
    logo_file_name { 'logo.png' }
    logo_content_type { 'image/png' }
    logo_file_size { 1024 }
  end
end
