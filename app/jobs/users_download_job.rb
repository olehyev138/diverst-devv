class UsersDownloadJob < ActiveJob::Base
    queue_as :default

    def perform(user_id)
        user = User.find_by_id(user_id)
        return if user.nil?

        enterprise = user.enterprise
        return if enterprise.nil?

        csv = enterprise.users_csv(nil)
        file = CsvFile.new(user_id: user.id, download_file_name: "users")

        file.download_file = StringIO.new(csv)
        file.download_file.instance_write(:content_type, 'text/csv')
        file.download_file.instance_write(:file_name, "users.csv")

        file.save!
    end
end
