FactoryBot.define do
  factory :field_data, class: 'FieldData' do |fd|
    association :field
    fd.field_user { |fa| fa.association(:user) }
  end
end
