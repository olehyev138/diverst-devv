FactoryGirl.define do
  factory :sponsor do
    sponsor_name "MyString"
    sponsor_title "MyString"
    sponsor_message "MyText"
    disable_sponsor_message false
    sponsorable nil
  end
end
