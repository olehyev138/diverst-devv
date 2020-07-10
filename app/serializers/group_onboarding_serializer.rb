class GroupOnboardingSerializer < ApplicationRecordSerializer
  attributes :id, :name, :private, :logo, :logo_file_name, :logo_data, :logo_content_type, :group_category, :children

  def children
    object.children.map { |child| GroupSerializer.new(child, scope: scope, scope_name: :scope, family: true).as_json }
  end

  def logo_location
    object.logo_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def logo
    AttachmentHelper.attachment_signed_id(object.logo)
  end

  def logo_file_name
    AttachmentHelper.attachment_file_name(object.logo)
  end

  def logo_data
    AttachmentHelper.attachment_data_string(object.logo)
  end

  def logo_content_type
    AttachmentHelper.attachment_content_type(object.logo)
  end
end
