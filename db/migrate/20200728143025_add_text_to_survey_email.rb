class AddTextToSurveyEmail < ActiveRecord::Migration
  def change
    Enterprise.all.each do |enterprise|
      survey_emails = enterprise.emails.where(name: 'Survey Mailer',
        mailer_name: 'poll_mailer')
      survey_emails.update_all(content: "<p>Hello %{user.name},</p>\r\n\r\n<p>You are invited to participate in the following online survey in Diverst: %{survey.title}</p>\r\n\r\n<p>%{click_here} to provide feedback and offer your thoughts and suggestions.</p>\r\n")
    end
  end
end
