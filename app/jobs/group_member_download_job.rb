class GroupMemberDownloadJob < ActiveJob::Base
    queue_as :default
    
    def perform(user_id, group_id)
        user = User.find_by_id(user_id)
        return if user.nil?
        
        group = Group.find_by_id(group_id)
        return if group.nil?
        
        csv_file = User.to_csv users: group.members, fields: group.enterprise.fields
        
        UsersDownloadMailer.send_csv(user.email, csv_file, "#{group.file_safe_name}_users.csv").deliver_later
    end
end