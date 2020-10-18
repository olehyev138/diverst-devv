class GroupMemberListDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, group_id, export_csv_params, filter_from, filter_to)
    user = User.find_by_id(user_id)
    return if user.nil?

    group = Group.find_by_id(group_id)
    return if group.nil?

    group_members = case export_csv_params
                    when 'active_members'
                      group.active_members
                    when 'inactive_members'
                      group.members.inactive
                    when 'pending_members'
                      group.pending_members
                    when 'parent_group_members'
                      group.parent.members
                    else
                      group.members
    end

    if group.pending_members_enabled?
      group_members = group.user_groups
        .where(user_id: group_members.ids)
        .where('`user_groups`.`updated_at` >= ?', filter_from)
        .where('`user_groups`.`updated_at` <= ?', filter_to)
        .map { |ug| [ug.user] }.flatten
    else
      group_members = group.user_groups
        .where(user_id: group_members.ids)
        .where('`user_groups`.`created_at` >= ?', filter_from)
        .where('`user_groups`.`created_at` <= ?', filter_to)
        .map { |ug| [ug.user] }.flatten
    end

    csv = group.membership_list_csv(group_members)
    file = CsvFile.new(user_id: user.id, download_file_name: "#{group.file_safe_name}_membership_list(#{export_csv_params})")

    file.download_file = StringIO.new(csv)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, "#{group.file_safe_name}_membership_list.csv")

    file.save!
  end
end
