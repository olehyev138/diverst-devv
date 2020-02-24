FactoryBot.define do
  factory :outlook_datum do
    user ''
    token_hash 'MyText'
    auto_add_event_to_calendar ''
    auto_update_calendar_event false
  end
end
