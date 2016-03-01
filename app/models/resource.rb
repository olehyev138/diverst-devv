class Resource < ActiveRecord::Base
  belongs_to :container, polymorphic: true
  belongs_to :owner, class_name: "User"

  has_attached_file :file, s3_permissions: :private, s3_protocol: :https
  validates_with AttachmentPresenceValidator, attributes: :file
  do_not_validate_attachment_file_type :file

  def file_extension
    File.extname(file_file_name)[1..-1].downcase
  rescue
    ''
  end
end
