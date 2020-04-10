class TokenHelper
  def token_to_object(token, klass:, name:)
    klass.find_by(name => token)
  end
end
