FactoryGirl.define do

  sequence :email do |n|
    "user#{n}@diverst.com"
  end

  factory :enterprise do
    name 'Hyperion'
    created_at Time.now
  end

  factory :employee do
    email
    password 'f4k3p455w0rd'
    invitation_created_at Time.now
    invitation_sent_at Time.now
    invitation_accepted_at Time.now
    enterprise
  end

  factory :admin do
    email
    password 'f4k3p455w0rd'
    enterprise
  end

  factory :employee_group do
    association :employee
    association :group
  end

  factory :group do
    name 'LGBT'
    enterprise

    factory :group_with_employees do
      transient do
        employees_count 100
      end

      after(:create) do |group, evaluator|
        create_list(:employee_group, evaluator.employees_count, group: group)
      end
    end
  end

  factory :event do
    title "Incredible event"
    description "This event is going to be awesome!"
    location "Montreal"
    max_attendees 15
    association :group, factory: :group_with_employees
  end

end