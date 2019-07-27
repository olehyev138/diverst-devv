class AddQrCodeToInitiatives < ActiveRecord::Migration[5.1]
  def change
    add_attachment :initiatives, :qr_code
  end
end
