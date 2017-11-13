class PollMailer < ApplicationMailer
  def invitation(poll, user)
    @poll = poll
    mail(to: user.email, subject: "You are invited to participate in a <Group name> survey!")
  end
end
