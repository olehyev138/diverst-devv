class ApplicationMailer < ActionMailer::Base
  helper Rails.application.routes.url_helpers # Allows us to call url helpers

  from_address = Mail::Address.new 'info@diverst.com'
  from_address.display_name = 'Diverst'
  default from: from_address, content_type: 'text/html', 'Content-Transfer-Encoding': '7bit'

  layout 'mailer'

  def set_defaults(enterprise, method_name)
    @from_address = Mail::Address.new enterprise.default_from_email_address.presence || 'info@diverst.com'
    @from_address.display_name = enterprise.default_from_email_display_name.presence || 'Diverst'

    email = enterprise.emails.find_by(mailer_name: mailer, mailer_method: method_name)
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
end
