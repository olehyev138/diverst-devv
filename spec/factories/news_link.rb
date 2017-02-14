FactoryGirl.define do
  factory :news_link do
    title 'Awesome news article'
    description 'This is the best news article out there!'
    url 'http://google.com'

    association :group, factory: :group_with_users
  end
end
