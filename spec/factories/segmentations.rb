FactoryGirl.define do
  factory :segmentation do
    association :child,   factory: :segment
    association :parent,  factory: :segment
  end
end
