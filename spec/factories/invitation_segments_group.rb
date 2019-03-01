FactoryBot.define do
  factory :invitation_segments_group do
    association :invitation_segment, factory: :segment
    association :group, factory: :group
  end
end
