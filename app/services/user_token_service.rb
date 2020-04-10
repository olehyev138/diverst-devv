require 'jwt'

class UserTokenService
  def self.create_jwt_token(payload)
    JWT.encode(payload, JWT_SECRET)
  end

  def self.create_jwt(user, params = {})
    token = user.generate_authentication_token

    payload = {
        user_token: token,
        time: (Time.now.to_f * 1000).to_i + 5000
    }

    Session.create!(
        status: 0,
        token: token,
        expires_at: Date.today + 30.days,
        user_id: user.id,
        device_type: params.dig(:device_type),
        device_name: params.dig(:device_name),
        device_version: params.dig(:device_version),
        operating_system: params.dig(:operating_system)
      )

    create_jwt_token(payload)
  end

  def self.verify_jwt_token(token)
    session = get_session_from_jwt(token)

    user_token_error if session.blank? || session.user.blank?

    session.user
  end

  def self.get_session_from_jwt(token)
    token = get_user_token(token)

    Session.find_by(token: token, status: 0)
  end

  def self.user_token_error
    raise BadRequestException.new 'Invalid User Token'
  end

  private

  def self.decode_jwt(token)
    JWT.decode(token, JWT_SECRET)
  rescue JWT::DecodeError
    user_token_error
  end

  def self.get_user_token(token)
    payload = decode_jwt(token)

    payload[0]['user_token']
  end

  JWT_SECRET = 'd1v3rS1tY1Sg0oD'.freeze
end
