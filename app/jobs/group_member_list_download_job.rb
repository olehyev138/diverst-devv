class GroupMemberListDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, group_id, export_csv_params)
    user = User.find_by_id(user_id)
    return if user.nil?

    group = Group.find_by_id(group_id)
    return if group.nil?

    group_members = group.members if export_csv_params == 'all_members'
    group_members = group.active_members if export_csv_params == 'active_members'
    group_members = group.members.inactive if export_csv_params == 'inactive_members'
    group_members = group.pending_members if export_csv_params == 'pending_members'

    csv = group.membership_list_csv(group_members)
    file = CsvFile.new(user_id: user.id, download_file_name: "#{group.file_safe_name}_membership_list(#{export_csv_params})")

    file.download_file = StringIO.new(csv)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, "#{group.file_safe_name}_membership_list.csv")

    file.save!
  end
end
