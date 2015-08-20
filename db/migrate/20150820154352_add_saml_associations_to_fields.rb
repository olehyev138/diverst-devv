class AddSamlAssociationsToFields < ActiveRecord::Migration
  def change
    change_table :fields do |t|
      t.string :saml_attribute
    end
  end
end
