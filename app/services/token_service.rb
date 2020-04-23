require 'jwt'

class TokenService
  def self.create_jwt_token(payload)
    JWT.encode(payload, JWT_SECRET)
  end

  def self.user_token_error(message = nil)
    raise BadRequestException.new(message || 'Invalid User Token')
  end

  protected

  def self.decode_jwt(token)
    JWT.decode(token, JWT_SECRET)
  rescue JWT::DecodeError
    user_token_error
  end

  JWT_SECRET = ENV['JWT_SECRET'] || 'd1v3rS1tY1Sg0oD'.freeze
end
