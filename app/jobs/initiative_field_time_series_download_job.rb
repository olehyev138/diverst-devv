class InitiativeFieldTimeSeriesDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, initiative_id, field_id, time_from = nil, time_to = nil)
    user = User.find_by_id(user_id)
    return if user.nil?

    initiative = Initiative.find_by_id(initiative_id)
    return if initiative.nil?

    csv = initiative.field_time_series_csv(field_id, time_from, time_to)
    file = CsvFile.new(user_id: user.id, download_file_name: "metrics#{ field_id }")

    file.download_file.attach(io: StringIO.new(csv), filename: "#{file.download_file_name}.csv", content_type: 'text/csv')

    file.save!
  end
end
