class MetricsUserGroupsIntersectionDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, users)
    user = User.find_by_id(user_id)
    return if user.nil?

    csv = CSV.generate do |csv_row|
      csv_row << ['ID', 'First name', 'Last name', 'Email']
      users.each { |u| csv_row << [u.id, u.first_name, u.last_name, u.email] }
    end

    file = CsvFile.new(user_id: user.id, download_file_name: 'users_intersection')

    file.download_file.attach(io: StringIO.new(csv), filename: "#{file.download_file_name}.csv", content_type: 'text/csv')

    file.save!
  end
end
