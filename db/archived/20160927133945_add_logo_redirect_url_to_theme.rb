class AddLogoRedirectUrlToTheme < ActiveRecord::Migration[5.1]
  def change
    change_table :themes do |t|
      t.string :logo_redirect_url, default: ''
    end
  end
end
