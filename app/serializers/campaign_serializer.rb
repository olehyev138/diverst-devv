class CampaignSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :start, :end, :nb_invites, :enterprise_id,
             :created_at, :updated_at, :image_file_name, :image_content_type, :image_file_size,
             :image_updated_at, :banner_file_name, :banner_content_type, :banner_file_size,
             :banner_updated_at, :owner_id, :status
end
