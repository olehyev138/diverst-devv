class PollMailer < ApplicationMailer
  def invitation(poll, user)
    @poll = poll
    subject = "You are Invited to participate in a '#{@poll.title}' survey"

    if @poll.groups.any?
      group_names = @poll.groups.map{ |g| g.name}.join(', ')
      subject += " for members of #{group_names}"
    end
    
    url = new_poll_poll_response_url(@poll)
    @mailer_text = user.enterprise.poll_mailer_notification_text  % { user_name: user.name, survey_name: @poll.title, click_here: "<a saml_for_enterprise=\"#{@poll.enterprise.id}\" href=\"#{url}\" target=\"_blank\">Click here</a>" }

    mail(to: user.email, subject: subject)
  end
end
