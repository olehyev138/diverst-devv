FactoryBot.define do
  factory :clockwork_database_event do
    name { 'Send Daily Notification of news to user_groups' }
    frequency_quantity { 1 }
    enterprise
    frequency_period
    disabled { false }
    job_name { 'UserGroupNotificationJob' }
    method_name { 'perform_later' }
    method_args { '{"notifications_frequency":"weekly"}' }
    tz { 'Eastern Time (US & Canada)' }
  end
end
