FactoryBot.define do
  factory :field do
    type 'TextField'
    title { Faker::Lorem.sentence(3) }
    gamification_value 1
    show_on_vcard false
    saml_attribute nil
    add_to_member_list false

    factory :checkbox_field do
      type 'CheckboxField'
      options_text "YES\nNO\nMAYBE"
    end

    factory :select_field do
      type 'SelectField'
      options_text "yes\nno\nmaybe"
    end

    factory :numeric_field do
      type 'NumericField'
      min 1
      max 100
    end

    factory :date_field do
      type 'DateField'
    end

    factory :segments_field do
      type 'SegmentsField'
    end

    factory :groups_field do
      type 'GroupsField'
    end

    match_exclude true
    match_polarity true
    match_weight 1

    factory :enterprise_field do
      association :enterprise, factory: :enterprise
    end
  end
end
