class Resource < ActiveRecord::Base
  belongs_to :container, polymorphic: true

  has_attached_file :file
  validates_attachment_content_type :file, content_type: /.*/

  def file_extension
    File.extname(file_file_name)[1..-1].upcase
  end
end