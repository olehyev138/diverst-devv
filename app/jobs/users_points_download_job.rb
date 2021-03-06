class UsersPointsDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    user = User.find_by_id(user_id)
    return if user.nil?

    enterprise = user.enterprise
    return if enterprise.nil?

    users = enterprise.users.order(points: :desc)
    return if users.empty?

    csv = enterprise.users_points_report_csv(users)
    file = CsvFile.new(user_id: user.id, download_file_name: 'users_points_report')

    file.download_file = StringIO.new(csv)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, "#{file.download_file_name}.csv")

    file.save!
  end
end
