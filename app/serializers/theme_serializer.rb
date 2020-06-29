class ThemeSerializer < ApplicationRecordSerializer
  attributes :branding_color, :charts_color, :use_secondary_color, :primary_color,
             :secondary_color, :logo_redirect_url, :logo, :logo_file_name, :logo_data, :logo_content_type

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
