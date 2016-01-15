class AddBrandingToEnterprise < ActiveRecord::Migration
  def change
    change_table :enterprises do |t|
      t.boolean :use_custom_branding
      t.attachment :logo
      t.string :primary_color
    end
  end
end
