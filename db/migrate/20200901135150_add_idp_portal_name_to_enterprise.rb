class AddIdpPortalNameToEnterprise < ActiveRecord::Migration
  def change
    add_column :enterprises, :idp_portal_name, :string
  end
end
