class AddAttachmentXmlSsoConfigToEnterprises < ActiveRecord::Migration[5.1]
  def self.up
    change_table :enterprises do |t|
      t.attachment :xml_sso_config
    end
  end

  def self.down
    remove_attachment :enterprises, :xml_sso_config
  end
end
