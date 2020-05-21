FactoryBot.define do
  factory :tag do
    association :resource, factory: :resource
    name 'label'
  end
end
