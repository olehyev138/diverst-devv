class WelcomeMailer < ApplicationMailer
  def notification(group_id, user_id)
    group, user = Group.find_by(id: group_id), User.find_by(id: user_id)

    return if group.nil? || user.nil?

    subject = "Hi #{user.name} and welcome to #{group.name}."

    return if user.enterprise.disable_emails?

    set_defaults(user.enterprise, method_name)

    mail(from: @from_address, to: user.email_for_notification, subject: subject)
  end
end
