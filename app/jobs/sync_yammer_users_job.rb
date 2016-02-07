class SyncYammerUsersJob < ActiveJob::Base
  queue_as :default

  def perform
    Enterprise.where(yammer_import: true).each do |enterprise|
      next if enterprise.yammer_token.blank? # Check if the enterprise has setup their Yammer integration
      yammer_users = HTTParty.get 'https://www.yammer.com/api/v1/users.json', headers: {
        'Authorization' => "Bearer #{enterprise.yammer_token}"
      }

      yammer_users.each do |yammer_user|
        primary_email = yammer_user['contact']['email_addresses'][0]['address']

        next if primary_email.blank? # If user has an email
        # Check if user doesn't already exist
        existing_emails = enterprise.users.all.map(&:email)
        unless existing_emails.include? primary_email
          user = User.from_yammer(yammer_user, enterprise: enterprise)
          user.invite!
        end
      end
    end
  end
end
