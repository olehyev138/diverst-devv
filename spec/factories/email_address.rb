FactoryGirl.define do
  sequence :email_address do |n|
    "user#{n}@diverst.com"
  end
end
