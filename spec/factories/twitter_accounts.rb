FactoryBot.define do
  factory :twitter_account do
    association :group, factory: :group
    sequence(:name) { |n| "Jacks Douglas #{n}" }
    account 'jacksfilms'
  end
end
