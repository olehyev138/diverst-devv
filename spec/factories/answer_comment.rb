FactoryGirl.define do
  factory :answer_comment do
    content 'This is a comment.'
    answer
    association :author, factory: :user
  end
end
