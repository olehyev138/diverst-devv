FactoryGirl.define do
  factory :field do
    type 'TextField'
    title { Faker::Lorem.sentence(3) }
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
end