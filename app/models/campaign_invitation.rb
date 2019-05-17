class CampaignInvitation < ApplicationRecord
  belongs_to :campaign
  belongs_to :user
end
