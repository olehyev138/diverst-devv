class ResourceSerializer < ApplicationRecordSerializer
  attributes :enterprise, :folder, :initiative, :group, :owner, :mentoring_session, :file_location, :permissions

  def serialize_all_fields
    true
  end
end
