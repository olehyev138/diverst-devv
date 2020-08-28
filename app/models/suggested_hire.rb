class SuggestedHire < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :user_reward_actions

  validates :email, uniqueness: true, format: { with: Devise.email_regexp }
  has_attached_file :resume, s3_permissions: 'private'
  validates_attachment_content_type :resume,
                                    content_type: ['text/plain', 'application/pdf'],
                                    message: 'This format is not supported'

  def resume_extension
    File.extname(resume_file_name)[1..-1].downcase
  rescue
    ''
  end
end
