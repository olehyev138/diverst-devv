class RsaEncryption
  RSA_INTERVAL = 100

  def self.public_key
    @public_key ||= OpenSSL::PKey::RSA.new(ENV['RSA_PUBLIC_KEY'])
  end

  def self.private_key
    @private_key ||= OpenSSL::PKey::RSA.new(ENV['RSA_PRIVATE_KEY'], ENV['PASSWORD'])
  end

  def self.encode(string)
    message_pieces = (0..(string.length / RSA_INTERVAL)).map do |interval|
      Base64.encode64(public_key.public_encrypt(string[interval * RSA_INTERVAL ... (interval + 1) * RSA_INTERVAL]))
    end
    message_pieces.join(';')
  end

  def self.decode(string)
    message_pieces = string.split(';')
    message_pieces.map! do |piece|
      private_key.private_decrypt(Base64.decode64(piece))
    end
    message_pieces.join
  end
end
