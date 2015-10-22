ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default charset: "utf-8"
ActionMailer::Base.smtp_settings = {
  port: 587,
  address: 'smtp.gmail.com',
  user_name: "frank.marineau@gmail.com",
  domain: 'gmail.com',
  password: "Youpidou2",
  authentication: :plain,
  enable_starttls_auto: true
}