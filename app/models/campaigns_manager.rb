class CampaignsManager < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :employee
end