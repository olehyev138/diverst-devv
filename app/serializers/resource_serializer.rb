class ResourceSerializer < ApplicationRecordSerializer
  attributes :enterprise, :folder, :initiative, :group, :owner, :mentoring_session, :file_location, :permissions,
             :file, :file_file_name, :file_data

  def serialize_all_fields
    true
  end

  # File
  def file
    AttachmentHelper.attachment_signed_id(object.file)
  end

  def file_file_name
    AttachmentHelper.attachment_file_name(object.file)
  end

  def file_data
    AttachmentHelper.attachment_data_string(object.file)
  end
end
