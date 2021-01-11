class AddIdpPortalNameToEnterprise < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless column_exists? :enterprises, :idp_portal_name
      add_column :enterprises, :idp_portal_name, :string
    end
  end
end
