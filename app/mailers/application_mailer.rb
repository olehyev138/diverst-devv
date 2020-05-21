class ApplicationMailer < ActionMailer::Base
  helper Rails.application.routes.url_helpers # Allows us to call url helpers
  include MailHelper

  from_address = Mail::Address.new 'info@diverst.com'
  from_address.display_name = 'Diverst'
  default from: from_address, content_type: 'text/html', 'Content-Transfer-Encoding': '7bit'

  layout 'mailer'
end
