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
    @searchable_columns ||= ['VideoRoom.name', 'VideoRoom.status',
                             'VideoRoom.duration', 'VideoRoom.participants']
  end

  private

  def data
    records.map do |record|
      [
        record.name,
        record.status,
        record.start_date,
        record.end_date,
        record.duration || 0,
        record.participants
      ]
    end
  end

  def get_raw_records
    @rooms
  end
end
