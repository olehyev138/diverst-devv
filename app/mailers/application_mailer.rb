class ApplicationMailer < ActionMailer::Base
  from_address = Mail::Address.new "le-facteur@volume7.ca"
  from_address.display_name = "Diverst"
  default from: from_address

  layout 'mailer'
end
