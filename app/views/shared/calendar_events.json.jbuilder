json.array! @events do |event|
  json.id     event.id
  json.title  event.title
  json.start  event.start
  json.end    event.end

  json.color  @branding_color || current_user.enterprise.theme.branding_color
  json.textColor @text_color || 'white'

  json.url    group_event_path(event.group, event)
end