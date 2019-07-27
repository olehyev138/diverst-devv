require 'base64'
require 'rqrcode'

module Initiative::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def build(diverst_request, params)
      item = super
      annual_budget = diverst_request.user.enterprise.annual_budgets.find_or_create_by(closed: false, group_id: item.group)
      item.annual_budget_id = annual_budget.id
      item.save!

      item
    end

    def generate_qr_code(diverst_request, params)
      item = show(diverst_request, params)
      enc = Base64.encode64(item.to_json)
      png = RQRCode::QRCode.new(enc).as_png
      item.qr_code = StringIO.new(png.to_s)
      item.save!
      item
    end
  end
end
