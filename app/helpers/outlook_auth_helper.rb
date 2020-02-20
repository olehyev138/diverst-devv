module OutlookAuthHelper
  # App's client ID. Register the app in Application Registration Portal to get this value.
  CLIENT_ID = ENV['OULOOK_APP_ID']
  CLIENT_SECRET = ENV['OULOOK_SEC_ID']

  # Scopes required by the app
  SCOPES = [
      'openid',
      'email',
      'profile',
      'offline_access',
      'User.Read',
      'Mail.Read',
      'Mail.Send',
      'Calendars.ReadWrite'
  ]

  # Generates the login URL for the app.
  def get_login_url
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                site: 'https://login.microsoftonline.com',
                                authorize_url: '/common/oauth2/v2.0/authorize',
                                token_url: '/common/oauth2/v2.0/token')

    login_url = client.auth_code.authorize_url(redirect_uri: omniauth_callback_url('outlook'), scope: SCOPES.join(' '))
  end

  def get_token_from_code(auth_code)
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                site: 'https://login.microsoftonline.com',
                                authorize_url: '/common/oauth2/v2.0/authorize',
                                token_url: '/common/oauth2/v2.0/token')

    token = client.auth_code.get_token(auth_code,
                                       redirect_uri: omniauth_callback_url('outlook'),
                                       scope: SCOPES.join(' '))
  end

  # Gets the current access token
  def get_access_token
    # Get the current token hash from session
    token_hash = session[:azure_token]

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
      session[:azure_token] = new_token.to_hash
      access_token = new_token.token
    else
      access_token = token.token
    end
  end
end
