class ChangePollSurveyText < ActiveRecord::Migration
  def change
    Enterprise.all.each do |enterprise|
      survey_emails = enterprise.emails.where(name: 'Poll Response Notification Mailer',
                              mailer_name: 'poll_response_mailer')
      survey_emails.update_all(name: 'Survey Response Notification Mailer')                        
    end
  end
end
