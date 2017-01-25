FactoryGirl.define do
  factory :checklist_item do

  end
  factory :checklist do

  end

  factory :budget do
    subject { FactoryGirl.create(:group) }
    description { Faker::Lorem.sentence }

    factory :approved_budget do
      after(:create) do |budget|
        budget.approve!
      end
    end

    after(:create) do |budget|
      create_list(:budget_item, 3, budget: budget)
    end
  end

  factory :budget_item do
    budget { FactoryGirl.create(:approved_budget) }

    title { Faker::Lorem.sentence }
    estimated_amount { rand(100..1000) }
    estimated_date { Faker::Date.between(Date.today, 1.year.from_now) }
    is_done { false }

    trait :done do
      is_done { true }
    end
  end

  factory :department do
    enterprise
    name "IT"
  end


  factory :city do
    name "MyString"
  end

  factory :event_attendance do

  end
  factory :sample do

  end
  factory :group_field do

  end
  factory :group_update do

  end
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
    policy_group
  end

  factory :policy_group do
    name "Policy group"
    enterprise

    campaigns_index true
    campaigns_create true
    campaigns_manage true

    polls_index true
    polls_create true
    polls_manage true

    events_index true
    events_create true
    events_manage true

    group_messages_index true
    group_messages_create true
    group_messages_manage true

    groups_index true
    groups_create true
    groups_manage true
    groups_members_index true
    groups_members_manage true

    metrics_dashboards_index true
    metrics_dashboards_create true

    news_links_index true
    news_links_create true
    news_links_manage true

    enterprise_resources_index true
    enterprise_resources_create true
    enterprise_resources_manage true

    segments_index true
    segments_create true
    segments_manage true

    users_index true
    users_manage true

    initiatives_index true
    initiatives_create true
    initiatives_manage true

    global_settings_manage true

    default_for_enterprise false
    admin_pages_view true

    budget_approval true
  end

  factory :user_group do
    association :user
    association :group
  end

  factory :initiative do |f|
    f.name { Faker::Lorem.sentence }
    f.description { Faker::Lorem.sentence }
    f.location { Faker::Address.city }
    f.start { Faker::Time.between(Date.today, 1.month.from_now) }
    f.end { Faker::Time.between(start, start + 10.days)}
    f.estimated_funding { 0 }
    f.owner_group { FactoryGirl.create(:group) }
    f.pillar { owner_group.try(:pillars).try(:first) }

    trait :with_budget_item do
      budget_item { FactoryGirl.create(:budget_item) }
      owner_group { budget_item.budget.subject }
      estimated_funding { rand(1..budget_item.available_amount ) }
    end
  end

  factory :pillar do
    name { Faker::Commerce.product_name }
  end

  factory :outcome do
    name { Faker::Commerce.product_name }

    after(:create) do |outcome|
      create_list(:pillar, 3, outcome: outcome)
    end
  end

  factory :group do
    name 'LGBT'
    enterprise

    factory :group_with_users do
      transient do
        users_count 10
      end

      after(:create) do |group, evaluator|
        create_list(:user_group, evaluator.users_count, group: group, accepted_member: true)
      end
    end

    trait :with_outcomes do
      after(:create) do |group|
        group.outcomes << create(:outcome, group: group)
      end
    end
  end

  factory :segment do
    name "Incredible segment"
    enterprise

    factory :segment_with_users do
      transient do
        users_count 10
      end

      after(:create) do |segment, evaluator|
        evaluator.members create_list(:user, evaluator.users_count, segments: [segment])
      end
    end

    factory :segment_with_rules do
      transient do
        rules_count 2
      end

      after(:create) do |segment, evaluator|
        evaluator.rules create_list(:segment_rule, evaluator.rules_count, segment: segment)
      end
    end
  end

  factory :segment_rule do
    segment
    field
    operator SegmentRule.operators[:equals]
    values ['abc'].to_json
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
    association :owner, factory: :user
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

    factory :resource_with_file do
      file = File.new(Rails.root + 'spec/fixtures/files/verizon_logo.png')
      file_file_name { file.path }
      file_content_type { 'image/png' }
      file_file_size { file.size }
    end
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
    secondary_color { generate(:hex_color) }

    logo_file_name { 'logo.png' }
    logo_content_type { 'image/png' }
    logo_file_size { 1024 }
  end
end
