FactoryGirl.define do
  factory :tag do
    association :taggable,   factory: :resource
    name "label"
  end
end
