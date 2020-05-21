class LogsDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, enterprise_id)
    user = User.find_by_id(user_id)
    return if user.nil?

    enterprise = Enterprise.find_by_id(enterprise_id)
    return if enterprise.nil?

    csv = enterprise.logs_csv
    file = CsvFile.new(user_id: user.id, download_file_name: "logs-#{enterprise.name}-#{Date.today}")

    file.download_file = StringIO.new(csv)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, "logs-#{enterprise.name}-#{Date.today}.csv")

    file.save!
  end
end
