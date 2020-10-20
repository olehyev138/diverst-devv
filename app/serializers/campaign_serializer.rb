class CampaignSerializer < ApplicationRecordSerializer
  attributes :title, :description, :start, :end, :status, :nb_invites, :permissions

  attributes_with_permission :groups, :image_location, :banner_location, if: :show_action?

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
