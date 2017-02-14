FactoryGirl.define do
  factory :email_variable do
    email
    key 'mysterious-variable'
    description 'This is a mysterious variable!'
    required false
  end
end
