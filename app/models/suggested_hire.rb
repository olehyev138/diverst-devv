class SuggestedHire < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :user_reward_actions

  validates :candidate_email, :manager_email, uniqueness: true, format: { with: Devise.email_regexp }
  has_attached_file :resume, s3_permissions: 'private'
  validates_attachment_content_type :resume,
                                    content_type: ['text/plain', 'application/pdf'],
                                    message: 'This format is not supported'

  after_create :send_email_to_manager

  def resume_extension
    File.extname(resume_file_name)[1..-1].downcase
  rescue
    ''
  end


  private 

  def send_email_to_manager
    SuggestHireToEnterpriseJob.perform_later(self.id)
  end
end
