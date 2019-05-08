class GroupFieldTimeSeriesDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, group_id, field_id)
    user = User.find_by_id(user_id)
    return if user.nil?

    group = Group.find_by_id(group_id)
    return if group.nil?

    csv = group.field_time_series_csv(field_id)
    file = CsvFile.new(user_id: user.id, download_file_name: "metrics#{ field_id }")

    file.download_file = StringIO.new(csv)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, "metrics#{ field_id }.csv")

    file.save!
  end
end
