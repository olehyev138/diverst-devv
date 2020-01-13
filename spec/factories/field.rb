FactoryBot.define do
  factory :field do
    type 'TextField'
    title { Faker::Lorem.sentence(3) }
    gamification_value 1
    show_on_vcard false
    saml_attribute nil
    association :field_definer, factory: :enterprise

    factory :checkbox_field, class: 'CheckboxField' do
      type 'CheckboxField'
      options_text "Yes\nNo"
    end

    factory :select_field, class: 'SelectField' do
      type 'SelectField'
      options_text "Yes\nNo"
    end

    factory :numeric_field, class: 'NumericField' do
      type 'NumericField'
      min 1
      max 100
    end

    factory :date_field, class: 'DateField' do
      type 'DateField'
    end

    factory :segments_field, class: 'SegmentsField' do
      type 'SegmentsField'
    end

    factory :groups_field, class: 'GroupsField' do
      type 'GroupsField'
    end

    match_exclude true
    match_polarity true
    match_weight 1

    factory :enterprise_field do
      association :field_definer, factory: :enterprise
    end
    factory :field_defined_by_group do
      association :field_definer, factory: :group
    end
    factory :field_defined_by_poll do
      association :field_definer, factory: :poll
    end
    factory :field_defined_by_initiative do
      association :field_definer, factory: :initiative
    end
  end
end
