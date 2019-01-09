FactoryGirl.define do
  factory :mentoring_session_comment do
    content "MyText"
    user nil
    mentoring_session nil
  end
end
