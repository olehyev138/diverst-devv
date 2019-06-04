LinkedIn.configure do |config|
  config.client_id     = ENV["LINKEDIN_ID"]
  config.client_secret = ENV["LINKEDIN_SECRET"]
  config.scope = 'r_liteprofile'
  config.redirect_uri  = "http://localhost:3001/omniauth/linkedin/callback"
end