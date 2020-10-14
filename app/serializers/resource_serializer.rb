class ResourceSerializer < ApplicationRecordSerializer
  attributes :owner, :file_location, :permissions,
             :file, :file_file_name, :file_file_path

  attributes_with_permission :folder, if: :show_action?

  def policies
    super + [:archive?]
  end

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

  def file_file_path
    object.path_for_file_download
  end
end
