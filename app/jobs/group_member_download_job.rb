class GroupMemberDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, group_id)
    user = User.find_by_id(user_id)
    return if user.nil?

    group = Group.find_by_id(group_id)
    return if group.nil?

    csv = User.to_csv users: group.members, fields: group.enterprise.fields
    file = CsvFile.new(user_id: user.id, download_file_name: "#{group.file_safe_name}_users")

    file.download_file = StringIO.new(csv)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, "#{group.file_safe_name}_users.csv")

    file.save!
  end
end
