require 'yammer'

class YammerClient
  def initialize(token)
    @token = token
  end

  def users
    HTTParty.get 'https://www.yammer.com/api/v1/users.json', {
      headers: {
        'Authorization' => "Bearer #{@token}"
      }
    }
  end

  def self.auth_client
    Yammer::OAuth2Client.new(ENV["YAMMER_CLIENT_ID"], ENV["YAMMER_CLIENT_SECRET"])
  end

  def self.access_token_from(authorization_code:)
    JSON.parse auth_client.access_token_from_authorization_code(authorization_code, { redirect_uri: "http://#{ENV["DOMAIN"]}/auth/yammer/callback"}).body
  end

  def self.webserver_authorization_url
    auth_client.webserver_authorization_url
  end

  # Used to define the Yammer fields you can map to Diverst fields when importing employees from Yammer
  def self.user_fields
    ["id", "network_id", "state", "guid", "job_title", "location", "significant_other", "kids_names", "interests", "summary", "expertise", "full_name", "activated_at", "auto_activated", "show_ask_for_photo", "first_name", "last_name", "network_name", "url", "web_url", "name", "mugshot_url", "mugshot_url_template", "birth_date", "timezone", "admin", "verified_admin", "supervisor_admin", "can_broadcast", "department", "email", "can_create_new_network", "can_browse_external_networks", "show_invite_lightbox"]
  end
end