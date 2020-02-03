require 'base64'
require 'rqrcode'

module Initiative::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  def finalize_expenses(diverst_request)
    raise BadRequestException.new "#{self.name.titleize} ID required" if id.blank?

    unless self.finish_expenses!
      raise InvalidInputException.new({ message: item.errors.full_messages.first, attribute: item.errors.messages.first.first })
    end

    self
  end

  module ClassMethods
    def valid_scopes
      ['upcoming', 'ongoing', 'past']
    end

    def generate_qr_code(diverst_request, params)
      item = show(diverst_request, params)
      hash = {
        id: item.id,
        name: item.name
      }
      enc = Base64.encode64(hash.to_json)
      png = RQRCode::QRCode.new(enc).as_png
      item.qr_code.attach(io: StringIO.new(png.to_s), filename: "#{item.name}_qr_code")
      item.save!
      item
    end
  end
end
