class CampaignSerializer < ApplicationRecordSerializer
  attributes :image_location, :banner_location, :groups, :questions, :title,
             :description, :start, :end, :status, :nb_invites, :permissions

  has_many :groups

  def image_location
    object.image_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def banner_location
    object.banner_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def serialize_all_fields
    true
  end
end
