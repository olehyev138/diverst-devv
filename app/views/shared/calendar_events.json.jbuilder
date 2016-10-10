json.array! @events do |event|
  json.id     event.id
  json.title  event.title
  json.start  event.start
  json.end    event.end

  json.color  current_user.enterprise.theme.branding_color
  json.textColor 'white'

  json.url    group_event_path(event.group, event)
end