class AddSsoMappingToUserName < ActiveRecord::Migration
  def change
    change_table :enterprises do |t|
      t.string :saml_first_name_mapping, after: :idp_cert
      t.string :saml_last_name_mapping, after: :saml_first_name_mapping
    end
  end
end
