class SuggestedHire < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :suggested_hire, class_name: 'User', foreign_key: :suggested_hire_id
  has_many :user_reward_actions
  
  validates :suggested_hire_id, presence: true
  has_attached_file :resume, s3_permissions: 'private'
  validates_attachment_content_type :resume,
                                    content_type: ['text/plain', 'application/pdf'],
                                    message: 'This format is not supported'

  def avatar
    suggested_hire.avatar unless suggested_hire.nil?
  end

  def name 
    suggested_hire.name unless suggested_hire.nil?
  end

  def resume_extension
    File.extname(resume_file_name)[1..-1].downcase
  rescue
    ''
  end
end
