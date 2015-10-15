class GroupMailer < ApplicationMailer
  def group_message(message)
    @subject = message.subject
    @content = message.content
    mail(to: message.employees.first.email, bcc: message.employees.pluck(:email), subject: @subject)
  end
end
