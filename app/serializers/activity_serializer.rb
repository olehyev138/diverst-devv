class ActivitySerializer < ApplicationRecordSerializer
  has_one :owner
  has_one :trackable

  def serialize_all_fields
    true
  end
end
