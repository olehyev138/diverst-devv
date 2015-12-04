class Resource < ActiveRecord::Base
  belongs_to :container, polymorphic: true

  has_attached_file :file
  validates_attachment_content_type :file, content_type: /.*/
end