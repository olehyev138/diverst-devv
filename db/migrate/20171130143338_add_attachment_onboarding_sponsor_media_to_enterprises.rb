class AddAttachmentOnboardingSponsorMediaToEnterprises < ActiveRecord::Migration
  def self.up
    change_table :enterprises do |t|
      t.attachment :onboarding_sponsor_media
    end
  end

  def self.down
    remove_attachment :enterprises, :onboarding_sponsor_media
  end
end
