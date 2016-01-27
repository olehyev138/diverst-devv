class CampaignsSegment < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :segment
end
