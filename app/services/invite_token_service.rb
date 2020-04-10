require 'jwt'

class InviteTokenService < TokenService
  TOKEN_EXPIRATION = 2.weeks

  def self.first_jwt(user, params = {})
    token = user.generate_invitation_token

    payload = {
        invite_token: token,
        user_id: user.id,
        type: 'invite'
    }

    create_jwt_token(payload)
  end

  def self.second_jwt(token)
    user = verify_jwt_token(token, 'invite')

    create_jwt_token({
                         user_id: user.id,
                         invite_token: user.invitation_token,
                         type: 'set_password'
                     })
  end

  def self.verify_jwt_token(token, type)
    user, payload = get_payload_from_jwt(token)

    user_token_error('Invalid Invitation Link') if user.blank? || payload['user_id'] != user.id
    user_token_error('Invalid Token') if payload['type'] != type
    user_token_error('Invitation Expired') if user.invitation_created_at < TOKEN_EXPIRATION.ago

    user
  end

  def self.get_payload_from_jwt(token)
    payload, _ = get_invite_payload(token)

    pp payload

    [User.find_by(invitation_token: payload['invite_token']), payload]
  end

  private

  def self.get_invite_payload(token)
    decode_jwt(token)
  end
end
