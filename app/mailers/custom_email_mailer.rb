class CustomEmailMailer < ApplicationMailer
  def custom(custom_email, emails)
    return unless custom_email.custom?

    set_defaults(custom_email.enterprise, 'custom')

    #TODO check emails are unique
    mail(from: @from_address, bcc: emails, subject: custom_email.subject)
  end
end
