require 'jwt'

class PasswordResetTokenService < TokenService
  TOKEN_EXPIRATION = Rails.configuration.password_reset_time_frame.hours
  FORM_EXPIRATION = 15.hours

  def self.request_token(user, params = {})
    token = user.reset_password_token

    payload = {
        reset_password_token: token,
        user_id: user.id,
        type: 'reset_password',
        created: Time.now,
    }

    create_jwt_token(payload)
  end

  def self.form_token(token)
    user = verify_jwt_token(token, 'reset_password')

    [
        create_jwt_token({
                             type: 'set_new_password',
                             user_id: user.id,
                             reset_password_token: user.reset_password_token,
                             created: Time.now,
                         }),
        user
    ]
  end

  def self.verify_jwt_token(token, type)
    user, payload = get_payload_from_jwt(token)

    user_token_error('Invalid Password Reset Link') if user.blank? || payload['user_id'] != user.id
    user_token_error('Invalid Token') if payload['type'] != type
    user_token_error('Token Expired') if case type
                                         when 'reset_password' then payload['created'] < TOKEN_EXPIRATION.ago
                                         when 'set_new_password' then payload['created'] < FORM_EXPIRATION.ago
                                         else true
                                         end

    user
  end

  def self.get_payload_from_jwt(token)
    payload, _ = get_reset_password_payload(token)

    [User.find_by(reset_password_token: payload['reset_password_token']), payload]
  end

  private

  def self.get_reset_password_payload(token)
    JWT.decode(token, JWT_SECRET)
  rescue JWT::DecodeError => e
    user_token_error('Invalid Token')
  end
end
