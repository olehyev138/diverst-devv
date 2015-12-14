class SyncYammerEmployeesJob < ActiveJob::Base
  queue_as :default

  def perform(enterprise)
    return if enterprise.yammer_token.blank? # Exit if the enterprise hasn't setup their Yammer integration

    yammer_users = HTTParty.get 'https://www.yammer.com/api/v1/users.json', {
      headers: {
        'Authorization' => "Bearer #{enterprise.yammer_token}"
      }
    }

    yammer_users.each do |yammer_user|
      primary_email = yammer_user["contact"]["email_addresses"][0]["address"]

      if !primary_email.blank? # If user has an email
        # Check if user doesn't already exist
        existing_emails = enterprise.employees.all.map(&:email)
        if !existing_emails.include? primary_email
          employee = Employee.from_yammer(yammer_user)
          enterprise.employees << employee
          employee.invite!
        else
          # TODO: Update existing employees from Yammer their info
        end
      end
    end
  end
end
