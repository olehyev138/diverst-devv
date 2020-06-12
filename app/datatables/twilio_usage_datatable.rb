class TwilioUsageDatatable < AjaxDatatablesRails::Base
  include ERB::Util

  def_delegator :@view, :link_to
  def_delegator :@view, :twilio_dashboard_path

  def initialize(view_context, rooms)
    super(view_context)
    @rooms = rooms
  end

  def sortable_columns
    @sortable_columns ||= ['VideoRoom.name',
                           'VideoRoom.status', 'VideoRoom.start_time', 'VideoRoom.end_time',
                           'VideoRoom.duration_per_minute', 'VideoRoom.number_of_participants',
                           'VideoRoom.billing']
  end

  def searchable_columns
    @searchable_columns ||= ['VideoRoom.status',
                             'VideoRoom.duration', 'VideoRoom.participants']
  end

  private

  def data
    records.order(id: :desc).map do |record|
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
    @rooms
  end
end
