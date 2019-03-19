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
            members = enterprise.users.joins(:segments).where(:segments => {:id => segment.id}).distinct
        else
            members = enterprise.users.joins(:segments, :groups).where(:segments => {:id => segment.id}, :groups => {:id => group_id}).distinct
        end

        csv = User.to_csv users: members, fields: segment.enterprise.fields
        file = CsvFile.new(user_id: user.id, download_file_name: "#{segment.name}")

        file.download_file = StringIO.new(csv)
        file.download_file.instance_write(:content_type, 'text/csv')
        file.download_file.instance_write(:file_name, "#{segment.name}.csv")

        file.save!
    end
end
