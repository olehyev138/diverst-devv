class TwilioUsageDatatable < AjaxDatatablesRails::Base
  def initialize(view_context, rooms)
    super(view_context)
    @rooms = rooms
  end

  def sortable_columns
    @sortable_columns ||= ['VideoRoom.name',
                           'VideoRoom.status', 'VideoRoom.start_date', 'VideoRoom.end_date',
                           'VideoRoom.duration', 'VideoRoom.participants']
  end

  def searchable_columns
    @searchable_columns ||= ['VideoRoom.status',
                             'VideoRoom.duration', 'VideoRoom.participants']
  end

  private

  def data
    records.map do |record|
      [
        record.event_name,
        record.status,
        record.start_date&.strftime('%a, %d %b %Y %H:%M %p'),
        record.end_date&.strftime('%a, %d %b %Y %H:%M %p'),
        "#{record.duration_per_minute.round(2)}min",
        record.number_of_participants,
        "$#{record.billing}"
      ]
    end
  end

  def get_raw_records
    @rooms
  end
end
