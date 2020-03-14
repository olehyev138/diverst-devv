class InitiativeSerializer < ApplicationRecordSerializer
  attributes :pillar, :owner, :budget, :outcome, :budget_status,
             :expenses_status, :current_expenses_sum, :leftover, :full?, :permissions,
             :picture, :picture_file_name, :picture_data, :qr_code, :qr_code_file_name, :qr_code_data,
             :total_comments, :is_attending

  has_many :comments
  belongs_to :budget_item

  def serialize_all_fields
    true
  end

  def policies
    [:index?, :create?, :update?, :destroy?, :show?]
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

  def is_attending
    scope&.dig(:current_user)&.is_attending?(object)
  end
end
