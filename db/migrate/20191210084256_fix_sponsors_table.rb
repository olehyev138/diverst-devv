class FixSponsorsTable < ActiveRecord::Migration[5.2]
  def change
    # This migration is necessary when migrating from the legacy app DB
    enterprise_id_exists = column_exists? :sponsors, :enterprise_id
    group_id_exists = column_exists? :sponsors, :group_id
    campaign_id_exists = column_exists? :sponsors, :campaign_id

    add_reference :sponsors, :sponsorable, polymorphic: true, index: true unless column_exists? :sponsors, :sponsorable_id

    Sponsor.find_each do |sponsor|
      if enterprise_id_exists && sponsor.enterprise_id
        sponsor.sponsorable = Enterprise.find(sponsor.enterprise_id)
      elsif group_id_exists && sponsor.group_id
        sponsor.sponsorable = Group.find(sponsor.group_id)
      elsif campaign_id_exists && sponsor.campaign_id
        sponsor.sponsorable = Campaign.find(sponsor.campaign_id)
      end

      sponsor.save!
    end

    remove_column :sponsors, :enterprise_id if enterprise_id_exists
    remove_column :sponsors, :group_id if group_id_exists
    remove_column :sponsors, :campaign_id if campaign_id_exists
  end
end
