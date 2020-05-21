class LinkedInClient
  def self.oauth
    @oauth ||= LinkedIn::OAuth2.new
  end

  def self.get_url
    oauth.auth_code_url
  end

  def self.get_access_token(code:)
    oauth.get_access_token(code)
  end

  def self.get_api(token:)
    LinkedIn::API.new(token)
  end

  def self.get_profile(token:)
    api = LinkedIn::API.new(token)
    api.profile
  end

  private

  def self.get_access(user, oauth, code)
    if access_cache[user] == nil || (access_cache.fetch user).expires_at < Time.now.to_i
      access_cache[user] = oauth.get_access_token(code)
    end
    access_cache.fetch user
  end
end
