FactoryBot.define do
  sequence :email_address do |n|
    "#{ n }#{ Faker::Internet.email }"
  end
end
