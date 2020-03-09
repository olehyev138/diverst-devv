class GroupMemberDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, group_id)
    user = User.find_by_id(user_id)
    return if user.nil?

    group = Group.find_by_id(group_id)
    return if group.nil?

    csv = User.to_csv_with_fields users: group.members, fields: group.enterprise.fields
    file = CsvFile.new(user_id: user.id, download_file_name: "#{group.file_safe_name}_users")

    file.download_file.attach(io: StringIO.new(csv), filename: "#{file.download_file_name}.csv", content_type: 'text/csv')

    file.save!
  end
end
