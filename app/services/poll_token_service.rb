require 'jwt'

class PollTokenService < TokenService
  RESPONSE_TIME_LIMIT = 2.hours

  def self.first_jwt(poll_token, params = {})
    payload = {
        poll_token: poll_token.token,
        type: 'first'
    }

    create_jwt_token(payload)
  end

  def self.second_jwt(token)
    poll_token = verify_jwt_token(token, 'first')

    [
        create_jwt_token({
                             poll_token: poll_token.token,
                             type: 'response',
                             created: Time.now,
                         }),
        PollResponse.create_prototype(poll_token.poll)
    ]
  end

  def self.verify_jwt_token(token, type)
    poll_token, payload = get_token_from_jwt(token)

    user_token_error('Invalid Poll Token') if poll_token.blank? || poll_token.poll.blank? || poll_token.cancelled?
    user_token_error('User Already Answered') if poll_token.submitted?
    user_token_error('Token Expired. Please Try again') if type == 'response' && payload['created'] < RESPONSE_TIME_LIMIT.ago

    poll_token
  end

  def self.get_token_from_jwt(token)
    payload, _ = get_poll_payload(token)

    [UserPollToken.find_by(token: payload['poll_token']), payload]
  end

  private

  def self.get_poll_payload(token)
    JWT.decode(token, JWT_SECRET)
  rescue JWT::DecodeError => e
    user_token_error('Invalid Token')
  end
end
