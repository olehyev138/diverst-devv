require 'jwt'

class UserTokenService
  def self.create_jwt_token(payload)
    JWT.encode(payload, JWT_SECRET)
  end

  def self.create_jwt(user, params = {})
    token = user.generate_authentication_token
    payload = {
        id: user.id,
        email: user.email,
        user_token: token,
        role: user.user_role.role_name,
        time_zone: ActiveSupport::TimeZone.find_tzinfo(user.time_zone).name,
        created_at: user.created_at.as_json,
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
    begin
      jwt = JWT.decode(token, JWT_SECRET)
    rescue JWT::DecodeError
      raise BadRequestException.new 'Invalid User Token'
    end
    token = jwt[0]['user_token']
    user = User.joins(:sessions).where(sessions: { token: token, status: 0 }).first

    if not user
      raise BadRequestException.new 'Invalid User Token'
    else
      user
    end
  end

  private

  JWT_SECRET = 'd1v3rS1tY1Sg0oD'.freeze
end
