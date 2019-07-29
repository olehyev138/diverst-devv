class InitiativeSerializer < ApplicationRecordSerializer
  attributes :pillar, :owner, :budget, :outcome, :budget_status,
             :expenses_status, :current_expences_sum, :leftover, :time_string,
             :full?, :picture_location, :qr_code_location

  def serialize_all_fields
    true
  end
end
