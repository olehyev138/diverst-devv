class CustomEmailMailer < ApplicationMailer
  def custom(custom_email_id, emails)
    @custom_email = Email.find custom_email_id
    return unless @custom_email.custom?

    set_defaults(@custom_email.enterprise, 'custom')

    # TODO check emails are unique
    mail(from: @from_address, to: emails, subject: @custom_email.subject)
  end

  def variables
    {
      enterprise: @custom_email.enterprise
    }
  end
end