class FixSponsorsTable < ActiveRecord::Migration[5.2]
  def change
    # This migration seems to be necessary for some reason when migrating from the legacy app DB

    add_reference :sponsors, :sponsorable, polymorphic: true, index: true unless column_exists? :sponsors, :sponsorable_id

    Sponsor.find_each do |sponsor|
      if sponsor.enterprise_id
        sponsor.sponsorable = Enterprise.find(enterprise_id)
      elsif sponsor.group_id
        sponsor.sponsorable = Group.find(group_id)
      elsif sponsor.campaign_id
        sponsor.sponsorable = Campaign.find(campaign_id)
      end

      sponsor.save!
    end

    remove_column :sponsors, :enterprise_id if column_exists? :sponsors, :enterprise_id
    remove_column :sponsors, :group_id if column_exists? :sponsors, :group_id
    remove_column :sponsors, :campaign_id if column_exists? :sponsors, :campaign_id
  end
end
