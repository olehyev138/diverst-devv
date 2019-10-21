class InitiativeSerializer < ApplicationRecordSerializer
  attributes :pillar, :owner, :budget, :outcome, :budget_status,
             :expenses_status, :current_expences_sum, :leftover,
             :full?, :picture_location, :qr_code_location

  def picture_location
    object.picture_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def qr_code_location
    object.qr_code_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def serialize_all_fields
    true
  end
end
