class UsersDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, export_csv_params)
    return if export_csv_params.nil?

    user = User.find_by_id(user_id)
    return if user.nil?

    enterprise = user.enterprise
    return if enterprise.nil?

    csv = enterprise.users_csv(nil, export_csv_params)
    file = CsvFile.new(user_id: user.id, download_file_name: export_csv_params.downcase.split(' ').join('_'))

    file.download_file = StringIO.new(csv)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, "#{file.download_file_name}.csv")

    file.save!
  end
end
