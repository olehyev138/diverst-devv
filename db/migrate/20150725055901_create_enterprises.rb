class CreateEnterprises < ActiveRecord::Migration
  def change
    create_table :enterprises do |t|
      t.string :name

      # SAML settings
      t.string :idp_entity_id
      t.string :idp_sso_target_url
      t.string :idp_slo_target_url
      t.text :idp_cert
      t.boolean :has_enabled_saml

      t.timestamps null: false
    end
  end
end
