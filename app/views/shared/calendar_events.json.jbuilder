json.array! @events do |event|
  json.id     event.id
  json.title  event.title
  json.start  event.start
  json.end    event.end

  json.color  @branding_color || current_user.enterprise.theme.try(:branding_color) || '#7571bf'
  json.textColor @text_color || 'white'

  json.url    group_event_path(event.group, event)
end