json.array! @events do |event|
  json.id     event.id
  json.title  event.name
  json.start  event.start
  json.end    event.end
  json.group_name event.owner_group.name

  json.color event_color(event)
  json.textColor @text_color || 'white'

  json.url group_event_path(event.owner_group, event) if event && event.owner_group
end
