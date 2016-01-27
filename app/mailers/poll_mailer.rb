class PollMailer < ApplicationMailer
  def invitation(poll, employee)
    @link = "http://#{ENV['DOMAIN']}#{new_poll_poll_response_path(poll)}"
    mail(to: employee.email, subject: 'Market Scope campaign invitation')
  end
end
