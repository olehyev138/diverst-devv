class RemovePolymorphicAssociationFromSponsorModel < ActiveRecord::Migration
  def up
    add_column :sponsors, :enterprise_id, :integer
    add_column :sponsors, :group_id, :integer
    add_column :sponsors, :campaign_id, :integer

    Enterprise.all.each do |enterprise|
      enterprise.sponsors.each do |sponsor|
        sponsor.enterprise_id = sponsor.sponsorable_id
        sponsor.save
      end

      enterprise.groups.joins(:sponsors).each do |group|
        group.sponsors.each do |sponsor|
          sponsor.group_id = sponsor.sponsorable_id
          sponsor.save
        end
      end

      enterprise.campaigns.joins(:sponsors).each do |campaign|
        campaign.sponsors.each do |sponsor|
          sponsor.campaign_id = sponsor.sponsorable_id
          sponsor.save
        end
      end
    end

    remove_column :sponsors, :sponsorable_id, :integer
    remove_column :sponsors, :sponsorable_type, :string
  end

  def down
  	add_column :sponsors, :sponsorable_id, :integer
  	add_column :sponsors, :sponsorable_type, :string

  	Sponsor.where.not(group_id: nil).each do |sponsor|
  	  sponsor.sponsorable_id = sponsor.group_id
  	  sponsor.sponsorable_type = 'Group'
  	  sponsor.save
  	end

  	Sponsor.where.not(enterprise_id: nil).each do |sponsor|
  	  sponsor.sponsorable_id = sponsor.enterprise_id
  	  sponsor.sponsorable_type = 'Enterprise'
  	  sponsor.save
  	end

  	Sponsor.where.not(campaign_id: nil).each do |sponsor|
  	  sponsor.sponsorable_id = sponsor.campaign_id
  	  sponsor.sponsorable_type = 'Campaign'
  	  sponsor.save
  	end

  	remove_column :sponsors, :campaign_id
  	remove_column :sponsors, :group_id
  	remove_column :sponsors, :enterprise_id
  end
end
