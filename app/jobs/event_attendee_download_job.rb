class EventAttendeeDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, initiative_id)
    user = User.find_by_id(user_id)
    return if user.nil?

    initiative = Initiative.find_by_id(initiative_id)
    return if initiative.nil?

    attendees = initiative.attendees
    return if attendees.empty?


    csv = User.basic_info_to_csv(users: attendees)
    file = CsvFile.new(user_id: user.id, download_file_name: 'event_attendees')

    file.download_file.attach(io: StringIO.new(csv), filename: "#{file.download_file_name}.csv", content_type: 'text/csv')

    file.save!
  end
end
