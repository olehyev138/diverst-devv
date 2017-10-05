FactoryGirl.define do
  factory :sample do
    user_id {create(:user).id}
    data {create(:user).data}
  end
end
