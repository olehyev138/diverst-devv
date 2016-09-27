class AddLogoRedirectUrlToTheme < ActiveRecord::Migration
  def change
    change_table :themes do |t|
      t.string :logo_redirect_url, default: ''
    end
  end
end
