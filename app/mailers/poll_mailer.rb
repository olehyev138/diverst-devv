class PollMailer < ApplicationMailer
  def invitation(poll, user)
    @link = "http://#{ENV['DOMAIN']}#{new_poll_poll_response_path(poll)}"
    @poll = poll
    mail(to: user.email, subject: 'Market Scope campaign invitation')
  end
end
