class InitiativeSerializer < ApplicationRecordSerializer
  attributes :pillar, :owner, :budget, :outcome, :budget_status,
             :expenses_status, :current_expenses_sum, :leftover, :full?,
             :picture, :picture_file_name, :picture_data,
             :qr_code, :qr_code_file_name, :qr_code_data, :group_name

  def serialize_all_fields
    true
  end

  # Picture

  def picture_location
    object.picture_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def picture
    AttachmentHelper.attachment_signed_id(object.picture)
  end

  def picture_file_name
    AttachmentHelper.attachment_file_name(object.picture)
  end

  def picture_data
    AttachmentHelper.attachment_data_string(object.picture)
  end

  # QR Code

  def qr_code
    AttachmentHelper.attachment_signed_id(object.picture)
  end

  def qr_code_file_name
    AttachmentHelper.attachment_file_name(object.picture)
  end

  def qr_code_data
    AttachmentHelper.attachment_data_string(object.picture)
  end

  def qr_code_location
    object.qr_code_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def group_name
    object.group.name
  end
end
