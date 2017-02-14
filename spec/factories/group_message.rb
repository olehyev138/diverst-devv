FactoryGirl.define do
  factory :group_message do
    subject 'Subject of an awesome message'
    content 'This is the coolest message content I\'ve seen in a while!'

    association :group, factory: :group_with_users
    association :owner, factory: :user
  end
end
