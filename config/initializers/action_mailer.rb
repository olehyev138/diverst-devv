ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default charset: 'utf-8'
ActionMailer::Base.smtp_settings = {
  port: 587,
  address: 'smtp.mandrillapp.com',
  user_name: ENV['MANDRILL_USERNAME'],
  password: ENV['MANDRILL_APIKEY'],
  domain: ENV['MANDRILL_DOMAIN'],
  authentication: :plain
}
