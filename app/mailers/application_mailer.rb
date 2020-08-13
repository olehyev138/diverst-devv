class ApplicationMailer < ActionMailer::Base
  helper Rails.application.routes.url_helpers # Allows us to call url helpers
  include MailHelper

  from_address = Mail::Address.new 'info@diverst.com'
  from_address.display_name = 'Diverst'
  default from: from_address, content_type: 'text/html', 'Content-Transfer-Encoding': '7bit'

  layout 'mailer'

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # Skip job when record is not found
  end
end
