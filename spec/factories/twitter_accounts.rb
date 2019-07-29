FactoryBot.define do
  factory :twitter_account do
    association :group, factory: :group
    sequence(:name) { |n| "Alex Oxorn #{n}" }
    account 'AOxorn'
  end
end
