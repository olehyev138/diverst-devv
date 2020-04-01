class OutcomeSerializer < ApplicationRecordSerializer
  attributes :group, :permissions

  has_many :pillars

  def serialize_all_fields
    true
  end
end
