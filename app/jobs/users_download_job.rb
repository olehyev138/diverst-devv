class UsersDownloadJob < ActiveJob::Base
    queue_as :default
    
    def perform(user_id)
        user = User.find_by_id(user_id)
        return if user.nil?
        
        enterprise = user.enterprise
        return if enterprise.nil?
        
        csv_file = enterprise.users_csv(nil)
        
        UsersDownloadMailer.send_csv(user.email, csv_file).deliver_later
    end
end