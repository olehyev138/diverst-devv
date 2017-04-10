json.array! @events do |event|
  json.id     event.id
  json.title  event.name
  json.start  event.start
  json.end    event.end

  calendar_color = event.try(:owner_group).try(:calendar_color).blank? ? nil : "#" + event.try(:owner_group).try(:calendar_color)

  json.color  calendar_color || @branding_color || enterprise_primary_color || '#7b77c9'
  json.textColor @text_color || 'white'

  json.url    group_event_path(event.owner_group, event) if event && event.owner_group
end
