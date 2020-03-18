LinkedIn.configure do |config|
  # ADD TO APPLICATION.YML
  LINKEDIN_ID = '86i5wy0c9w6pix'
  LINKEDIN_SECRET = 'ZOApM00DtGp3urbo'

  config.client_id = LINKEDIN_ID || ENV['LINKEDIN_ID']
  config.client_secret = LINKEDIN_SECRET || ENV['LINKEDIN_SECRET']
  config.scope = 'r_liteprofile'
  config.redirect_uri = "http#{'s' if ENV['DOMAIN'].present?}://#{ENV['DOMAIN'] || 'localhost:3001'}/omniauth/linkedin/callback"
end
