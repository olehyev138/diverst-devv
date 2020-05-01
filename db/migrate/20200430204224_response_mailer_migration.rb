class ResponseMailerMigration < ActiveRecord::Migration
  def change
    Enterprise.all.each do |enterprise|
      survey_response_email = enterprise.emails.find_or_create_by(name: 'Survey Response Notification Mailer')
      puts "About to update #{survey_response_email.name}"
      survey_response_email.update(:enterprise => enterprise,
        :mailer_name => 'poll_mailer',
        :mailer_method => 'survey_response_notification',
        :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>This is to confirm that your response to our survey has been received. Thank you for your participtaion!</p>",
        :subject => "Thank you for participating in our '%{survey.title} survey",
        :description => "Email that goes out to users after they have submitted a response to a survey.",
        :template => "")

    
      enterprise.email_variables.where(key: ["user.name", "survey.title", "enterprise.name"]).each do |email_variable|
        email_variable.emails << survey_response_email
      end
    end
  end
end
