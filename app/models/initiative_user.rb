class InitiativeUser < BaseClass
  belongs_to :initiative
  belongs_to :user, counter_cache: :initiatives_count

  after_create :create_callback
  before_destroy :delete_outlook_event

  def create_callback
    if user.outlook_datum.present? && user.outlook_datum.auto_add_event_to_calendar?
      update_outlook
    end
  rescue OData::ClientError
    # ignored
  end

  def update_outlook
    graph = user.outlook_graph
    if graph.present?
      patch_outlook_event(graph)
    end
    true
  rescue => err
    if err.message.include?('404 ErrorItemNotFound') || err.message.include?('Nil OutlookId')
      update(outlook_id: create_outlook_event(graph)&.id)
    else
      false
    end
  end

  def self.batch_update
    query = self.all
              .includes([:user, user: [:outlook_datum]])
              .preload(:initiative)
              .references(:outlook_datum)
              .where('outlook_data.auto_update_calendar_event = TRUE AND outlook_data.encrypted_token_hash IS NOT NULL')

    query.find_each do |participation|
      participation.update_outlook
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

  def delete_outlook_event
    graph = user.outlook_graph
    if graph.present? && outlook_id.present?
      event = graph.me.events.find(outlook_id)
      event.delete!
    end
  end
end
