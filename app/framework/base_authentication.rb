module BaseAuthentication
  attr_accessor :current_user
  attr_accessor :diverst_request

  # verify the JWT token, load the user and abilities
  def verify_jwt_token
    token = request.headers['Diverst-UserToken']

    unless token
      token = params['Diverst-UserToken']
    end

    unless token
      render status: 401, json: { message: 'Invalid User Token' }
      return
    end

    begin
      # get the user from the token
      self.current_user = UserTokenService.verify_jwt_token token
      # add the remaining data to the response
      self.diverst_request.user = current_user
      self.diverst_request.policy_group = current_user.policy_group
    rescue => e
      render status: :unauthorized, json: { message: e.message }
    end
  end

  # verify there is an api key in the request
  def verify_api_key
    api_key = request.headers['Diverst-APIKey']

    if api_key.nil?
      api_key = params[:api_key]
      if api_key.nil?
        render status: 403, json: { message: 'Invalid API Key' }
        return
      end
    end

    api_key_object = ApiKey.find_by_key(api_key)

    if api_key_object.nil?
      render status: 403, json: { message: 'Invalid API Key' }
    end
  end

  def init_response
    self.diverst_request = Request.new
    self.diverst_request.controller = controller_name
    self.diverst_request.action = action_name
  end
end