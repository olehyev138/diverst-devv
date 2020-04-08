class ActivitySerializer < ApplicationRecordSerializer
  attributes :user

  def serialize_all_fields
    true
  end

end
