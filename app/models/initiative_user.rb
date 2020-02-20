class InitiativeUser < BaseClass
  belongs_to :initiative
  belongs_to :user, counter_cache: :initiatives_count

  def update_outlook(graph)
    patch_outlook_event(graph)
    true
  rescue => err
    if err.message.include?('404 ErrorItemNotFound') || err.message.include?('Nil OutlookId')
      update(outlook_id: create_outlook_event(graph)&.id)
    else
      false
    end
  end

  private

  def to_outlook_json
    {
        subject: initiative.name,
        body: {
            contentType: 'HTML',
            content: initiative.description
        },
        start: {
            dateTime: initiative.start.iso8601,
            timeZone: Time.zone.to_s
        },
        end: {
            dateTime: initiative.end.iso8601,
            timeZone: Time.zone.to_s
        },
        location: {
            displayName: initiative.location
        },
    }
  end

  def create_outlook_event(graph)
    graph.me.events.create(to_outlook_json)
  end

  def patch_outlook_event(graph)
    raise StandardError.new('Nil OutlookId') if outlook_id.blank?

    event = graph.me.events.find(outlook_id)

    event.start.date_time = initiative.start.iso8601
    event.end.date_time = initiative.end.iso8601
    event.subject = initiative.name
    event.body.content = initiative.description
    event.location.display_name = initiative.location

    event.save!
  end

  def delete_outlook_event(graph, id)
  end
end
