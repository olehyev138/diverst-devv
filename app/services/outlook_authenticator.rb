class OutlookAuthenticator
  # App's client ID. Register the app in Application Registration Portal to get this value.
  CLIENT_ID = ENV['OULOOK_APP_ID']
  CLIENT_SECRET = ENV['OULOOK_SEC_ID']

  # Scopes required by the app
  SCOPES = [
    'openid',
    'email',
    'profile',
    'User.Read',
    'offline_access',
    'Calendars.ReadWrite'
  ]

  HOST = Rails.application.routes.default_url_options[:host]
  PROTOCOL = HOST.start_with?('localhost') ? 'http' : 'https'
  CALLBACK = Rails.application.routes.url_helpers.omniauth_callback_url('outlook', protocol: PROTOCOL)

  # Generates the login URL for the app.
  def self.get_login_url
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                site: 'https://login.microsoftonline.com',
                                authorize_url: '/common/oauth2/v2.0/authorize',
                                token_url: '/common/oauth2/v2.0/token')

    client.auth_code.authorize_url(redirect_uri: CALLBACK, scope: SCOPES.join(' '))
  end

  def self.get_token_from_code(auth_code)
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                site: 'https://login.microsoftonline.com',
                                authorize_url: '/common/oauth2/v2.0/authorize',
                                token_url: '/common/oauth2/v2.0/token')

    client.auth_code.get_token(auth_code,
                               redirect_uri: CALLBACK,
                               scope: SCOPES.join(' '))
  end

  # Gets the current access token
  def self.get_access_token(user_arg = nil)
    user = case user_arg
           when Integer then User.find(user_arg)
           when User then user_arg
           else current_user
    end

    token_hash = user.outlook_token_hash

    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                site: 'https://login.microsoftonline.com',
                                authorize_url: '/common/oauth2/v2.0/authorize',
                                token_url: '/common/oauth2/v2.0/token')

    token = OAuth2::AccessToken.from_hash(client, token_hash)

    # Check if token is expired, refresh if so
    if token.expired?
      new_token = token.refresh!
      # Save new token
      user.set_outlook_token new_token.to_hash
      new_token.token
    else
      token.token
    end
  end

  def self.get_graph(token)
    if token
      # If a token is present in the session, get contacts
      callback = Proc.new do |r|
        r.headers['Authorization'] = "Bearer #{token}"
      end

      MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0',
                         cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                         &callback)
    else
      raise RuntimeError
    end
  end

  def self.has_outlook
    get_access_token.present?
  rescue
    false
  end
end
