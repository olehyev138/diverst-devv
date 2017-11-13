class PollMailer < ApplicationMailer
  def invitation(poll, user)
    @poll = poll
    subject = "You are Invited to participate in a '#{@poll.title}' survey"

    if @poll.groups.any?
      group_names = @poll.groups.map{ |g| g.name}.join(', ')
      subject += "(for members of #{group_names})"
    end

    mail(to: user.email, subject: subject)
  end
end
