class ActivitySerializer < ApplicationRecordSerializer
  attributes :trackable

  has_one :user

  def serialize_all_fields
    true
  end
end
