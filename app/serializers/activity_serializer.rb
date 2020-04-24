class ActivitySerializer < ApplicationRecordSerializer
  has_one :owner, :trackable, :user

  def serialize_all_fields
    true
  end
end
