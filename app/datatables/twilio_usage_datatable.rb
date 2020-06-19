class TwilioUsageDatatable < AjaxDatatablesRails::Base
  include ERB::Util

  def_delegator :@view, :link_to
  def_delegator :@view, :twilio_dashboard_path

  def initialize(view_context, rooms)
    super(view_context)
    @rooms = rooms
  end

  def sortable_columns
    @sortable_columns ||= ['VideoRoom.event_name',
                           'VideoRoom.start_time', 'VideoRoom.end_time',
                           'VideoRoom.duration', 'VideoRoom.participants',
                           'VideoRoom.billing']
  end

  def searchable_columns
    @searchable_columns ||= ['VideoRoom.event_name', 'VideoRoom.participants']
  end

  private

  def data
    records.map do |record|
      [
        "#{link_to(record.event_name, twilio_dashboard_path(record), class: "#{record.status == 'completed' ? 'positive' : 'error'}")}",
        record.start_time,
        record.end_time,
        record.duration_per_minute,
        record.number_of_participants,
        "$#{record.billing}"
      ]
    end
  end

  def get_raw_records
    @rooms.order(id: :desc)
  end
end
