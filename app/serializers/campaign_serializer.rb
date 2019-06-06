class CampaignSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :start, :end, :enterprise_id, :created_at, :updated_at, :owner_id, :status
  :nb_invites
end
