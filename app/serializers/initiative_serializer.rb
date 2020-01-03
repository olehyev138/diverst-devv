class InitiativeSerializer < ApplicationRecordSerializer
  attributes :pillar, :owner, :budget, :outcome, :budget_status,
             :expenses_status, :current_expences_sum, :leftover,
             :full?, :picture_data, :picture, :picture_file_name

  def picture_location
    object.picture_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def picture
    object.picture.signed_id if object.picture.attached?
  end

  def picture_file_name
    object.picture.filename.to_s if object.picture.attached?
  end

  def picture_data
    Base64.encode64(object.picture.download) if object.picture.attached?
  end

  def qr_code_location
    object.qr_code_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def serialize_all_fields
    true
  end
end
