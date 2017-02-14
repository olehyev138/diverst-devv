FactoryGirl.define do
  factory :email do
    name 'Awesome Email'
    slug { Faker::Internet.slug('awesome email', '-') }
    use_custom_templates true
    custom_html_template '<strong>Hey there</strong>'
    custom_txt_template 'Hey there'

    enterprise

    factory :email_with_variables do
      transient do
        variable_count 5
      end

      after(:create) do |email, evaluator|
        evaluator.variables create_list(:email_variable, evaluator.variable_count, email: email)
      end
    end
  end
end
