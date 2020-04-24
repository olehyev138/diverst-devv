class ActivitySerializer < ApplicationRecordSerializer
  has_one :owner
  has_one :trackable
  has_one :user

  def serialize_all_fields
    true
  end
end
