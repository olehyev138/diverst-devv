class Answer < BaseClass
  include PublicActivity::Common

  belongs_to :question, inverse_of: :answers, counter_cache: true
  belongs_to :author, class_name: 'User', inverse_of: :answers

  has_many :votes, class_name: 'AnswerUpvote', dependent: :destroy
  has_many :voters, through: :votes, class_name: 'User', source: :user
  has_many :comments, class_name: 'AnswerComment', dependent: :destroy
  has_many :expenses, class_name: 'AnswerExpense', dependent: :destroy
  has_many :user_reward_actions
  has_many :likes, dependent: :destroy

  belongs_to :contributing_group, class_name: 'Group'
  belongs_to :idea_category

  has_attached_file :supporting_document, s3_permissions: 'private'
  validates_attachment_content_type :supporting_document,
                                    content_type: ['text/plain', 'application/pdf'],
                                    message: 'This format is not supported', if: Proc.new { |a| a.content.blank? && a.video_upload.blank? }

  has_attached_file :video_upload, s3_permissions: 'private'
  validates_attachment_content_type :video_upload,
                                    content_type: ['video/mp4', 'video/webm'],
                                    message: 'This format is not supported', if: Proc.new { |a| a.content.blank? && a.supporting_document.blank? }

  accepts_nested_attributes_for :expenses, reject_if: :all_blank, allow_destroy: true

  validates_length_of :video_upload_content_type, maximum: 191
  validates_length_of :video_upload_file_name, maximum: 191

  validates_length_of :supporting_document_content_type, maximum: 191
  validates_length_of :supporting_document_file_name, maximum: 191
  validates_length_of :outcome, maximum: 65535
  validates_length_of :content, maximum: 65535
  validates :question, presence: true
  validates :author, presence: true
  validates :content, presence: true, if: Proc.new { |a| a.supporting_document.blank? && a.video_upload.blank? }
  validates :title, presence: true
  validates :idea_category, presence: true

  after_create :send_email_notification

  def supporting_document_extension
    File.extname(supporting_document_file_name)[1..-1].downcase
  rescue
    ''
  end

  # Base value + total of income items - total of expense items
  def total_value
    return 0 if self.value.nil?

    self.value + self.expenses.includes(:expense).map { |e|
      (e.quantity || 0) * (e.expense.signed_price || 0)
    }.sum
  end

  settings do
    mappings dynamic: false do
      indexes :upvote_count, type: :integer
      indexes :contributing_group do
        indexes :name, type: :keyword
      end
      indexes :author do
        indexes :enterprise_id, type: :integer
        indexes :id, type: :integer
      end
      indexes :question do
        indexes :campaign_id
      end
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      options.merge(
        only: [:upvote_count],
        include: { author: { only: [:enterprise_id, :id] },
                   question: { only: [:campaign_id] },
                   contributing_group: { only: [:name] } },
        methods: [:total_votes]
      )
    )
  end


  private

  def send_email_notification
    CampaignResponseNotifierJob.perform_later(self.id, self.question.campaign_id)
  end
end
