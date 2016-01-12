class ApplicationMailer < ActionMailer::Base
  helper Rails.application.routes.url_helpers # Allows us to call url helpers

  from_address = Mail::Address.new "le-facteur@volume7.ca"
  from_address.display_name = "Diverst"
  default from: from_address

  layout 'mailer'
end
