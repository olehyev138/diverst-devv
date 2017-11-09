class PollMailer < ApplicationMailer
  def invitation(poll, user)
    @poll = poll
    @group = Group.find_by(owner_id: user.id)
    mail(to: user.email, subject: "You are invited to participate in a #{@group.name} survey!")
  end
end
