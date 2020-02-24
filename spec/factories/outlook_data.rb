FactoryBot.define do
  factory :outlook_datum do
    user { build :user }
    token_hash '{token: \'HELLO\'}'
    auto_add_event_to_calendar true
    auto_update_calendar_event true
  end
end
