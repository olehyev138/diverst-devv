class PollMailer < ApplicationMailer
  def invitation(poll, user)
    @poll = poll
    mail(to: user.email, subject: "You are Invited to participate in a '#{@poll.title}' survey")
  end
end
