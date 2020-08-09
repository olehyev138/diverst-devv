class SuggestedHire < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :suggested_hire, class_name: 'User', foreign_key: :suggested_hire_id

  has_attached_file :resume, s3_permissions: 'private'
  validates_attachment_content_type :resume,
                                    content_type: ['text/plain', 'application/pdf'],
                                    message: 'This format is not supported'
end
