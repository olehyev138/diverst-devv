FactoryBot.define do
  factory :field_data, class: 'FieldData' do |fd|
    association :field
    fd.fieldable { |fa| fa.association(:user) }
  end
end
