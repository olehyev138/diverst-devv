class PollMailer < ApplicationMailer
  def invitation(poll, user)
    @poll = poll
    mail(to: user.email, subject: 'Market Scope campaign invitation')
  end
end
