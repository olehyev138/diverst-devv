class RsaEncryption
  # TO ADD TO APPLICATION.YML
  RSA_PUBLIC_KEY = '-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCwJbvJ/gxE2cs3h8+SU3UO3OJR
UjnuvxQuK6xtR5BHV5/a+WRaLGAH3QvWWxKZPtuTXcX1oZJXJ9CcTU2fwNjxYL8K
gKeNGZuRH7T4rhqd7m9zEEO6kLt1UGVQywlt7NYZRuJ5vSIEzMHaQuPKfiGt/Av5
i0NxNkbxEm6pt6AvKwIDAQAB
-----END PUBLIC KEY-----'

  RSA_PRIVATE_KEY = '-----BEGIN RSA PRIVATE KEY-----
MIICXQIBAAKBgQCwJbvJ/gxE2cs3h8+SU3UO3OJRUjnuvxQuK6xtR5BHV5/a+WRa
LGAH3QvWWxKZPtuTXcX1oZJXJ9CcTU2fwNjxYL8KgKeNGZuRH7T4rhqd7m9zEEO6
kLt1UGVQywlt7NYZRuJ5vSIEzMHaQuPKfiGt/Av5i0NxNkbxEm6pt6AvKwIDAQAB
AoGAJtn7xH6zSBBdoT7kSpr7y65ugI9JVd5xXgml+2h4azPpf0vYlYcKG1HnBX2K
6aASoDtjqVzcwTp36bGnOGA5uQyiUiIL/e6vKxV2w+9JIc855NRm1d8My33LW/W/
cr7yHK72N6bZ6JPggX0Otb2I4zINLJ3wMrvB6KI5KDVJe/kCQQD7VqY18RYdSXYi
Mbzu1PNqX7s9YWamjUVXW0zbQP7QKJtC5hdSZhzmb77ioQeOntVJQxF2k1jVsEyT
mkGIwM1tAkEAs2oUDvTgK/6fu/hX7E7Nhb/GBaWzf5bKpIds2X8R5Yfmc3AAx50e
OHDvDicwu+2XGeL7VGmGscu2gRmubmwH9wJAfV1GAGflQOxweTPX6kTbuTZQ3Zfk
rLSQXrdSiZZMwyVN9DtybI40Yhhg3Qe3DkNZXXaPklaCm+uY9pKdl4mbrQJBAKig
0juAgtY22rFUaGcNZfQI3DjglgYcl1fuhSsjWJHQmpPzOHhlP0szMiyuPwrS84r8
INck29luK5nJpn3Ygd8CQQCNwc/QxhzX4IYIoKRVmc0MhyaP2Ddtg2wMiaykR6kr
j41rz5mIn4VlbjpZlHGXnugjTrtKd4L6kydCCk7VTyXJ
-----END RSA PRIVATE KEY-----'

  PASSWORD = 'TDefww983nvr7snE9ense4356fvdv'

  RSA_INTERVAL = 100

  def self.public_key
    @public_key ||= OpenSSL::PKey::RSA.new(ENV['RSA_PUBLIC_KEY'] || RSA_PUBLIC_KEY)
  end

  def self.private_key
    @private_key ||= OpenSSL::PKey::RSA.new(ENV['RSA_PRIVATE_KEY'] || RSA_PRIVATE_KEY, ENV['PASSWORD'] || PASSWORD)
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