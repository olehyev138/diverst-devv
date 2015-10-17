class GroupMailer < ApplicationMailer
  def group_message(message)
    @subject = message.subject
    @content = message.content
    mail(to: message.employees.first.email, bcc: message.employees.pluck(:email), subject: @subject)
  end

  def invitation(group)
    @group = group
    mail(to: group.employees_to_invite.first.email, bcc: group.employees_to_invite.pluck(:email), subject: "You've been invited to join a new ERG")
  end
end
