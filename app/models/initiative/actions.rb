require 'base64'
require 'rqrcode'

module Initiative::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def generate_qr_code(diverst_request, params)
      item = show(diverst_request, params)
      enc = Base64.encode64(item.to_json)
      { qr_code: RQRCode::QRCode.new(enc).to_s }
    end
  end
end
