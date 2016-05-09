class PollMailer < ApplicationMailer
  def invitation(poll, user)
    @link = "http://#{ENV['DOMAIN']}#{new_poll_poll_response_path(poll)}"
    mail(to: user.email, subject: 'Market Scope campaign invitation')
    @poll = poll
  end
end
