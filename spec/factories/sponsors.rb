FactoryBot.define do
  factory :sponsor do
    sponsor_name 'MyString'
    sponsor_title 'MyString'
    sponsor_message 'MyText'
    disable_sponsor_message false
    association :sponsorable, factory: :enterprise
  end
end
