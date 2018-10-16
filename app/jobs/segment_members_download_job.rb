class SegmentMembersDownloadJob < ActiveJob::Base
    queue_as :default
    
    def perform(user_id, segment_id, group_id = nil)
        user = User.find_by_id(user_id)
        return if user.nil?
        
        enterprise = Enterprise.find_by_id(user.enterprise_id)
        return if enterprise.nil?
        
        segment = Segment.find_by_id(segment_id)
        return if segment.nil?
        
        if group_id.blank?
            members = enterprise.users.joins(:segments, :groups).where(:segments => {:id => segment.id}, :groups => {:id => group_id}).distinct
        else
            members = enterprise.users.joins(:segments).where(:segments => {:id => segment.id}).distinct
        end
        
        csv_file = User.to_csv users: members, fields: segment.enterprise.fields
        
        UsersDownloadMailer.send_csv(user.email, csv_file, "#{segment.name}.csv").deliver_later
    end
end