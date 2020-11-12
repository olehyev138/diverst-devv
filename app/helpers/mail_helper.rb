module MailHelper
  def set_defaults(enterprise, method_name)
    if enterprise.redirect_all_emails? && enterprise.redirect_email_contact.present?
      @email = enterprise.redirect_email_contact
    elsif enterprise.redirect_all_emails? && enterprise.redirect_email_contact.blank?
      # fallback
      @email = ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com'
    end

    @from_address = Mail::Address.new enterprise.default_from_email_address.presence || 'info@diverst.com'
    @from_address.display_name = enterprise.default_from_email_display_name.presence || 'Diverst'

    email = Email.find_by(mailer_name: mailer, mailer_method: method_name, enterprise: enterprise)

    return if email.nil?

    @mailer_text = email.process_content(variables)
    @subject = email.process_subject(variables)
  end

  def mailer
    self.class.name.underscore
  end

  def variables
  end

  def method_name
    caller[0] =~ (/`([^']*)'/) && $1
  end

  def enterprise_logo_url(enterprise = nil)
    enterprise_logo_or_default_('diverst-logo.svg', enterprise)
  end


  private

  def enterprise_logo_or_default_(default_logo_name, enterprise = nil)
    if enterprise && enterprise.theme.present? && enterprise.theme.logo.present?
      image_url(enterprise.theme.logo.expiring_url(3601))
    else
      image_url(default_logo_name)
    end
  end
end
