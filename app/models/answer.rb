class Answer < BaseClass
    include PublicActivity::Common

    belongs_to :question, inverse_of: :answers
    belongs_to :author, class_name: 'User', inverse_of: :answers

    has_many :votes, class_name: 'AnswerUpvote', dependent: :destroy
    has_many :voters, through: :votes, class_name: 'User', source: :user
    has_many :comments, class_name: 'AnswerComment', dependent: :destroy
    has_many :expenses, class_name: "AnswerExpense", dependent: :destroy
    has_many :user_reward_actions
    has_many :likes, dependent: :destroy

    has_attached_file :supporting_document, s3_permissions: "private"
    do_not_validate_attachment_file_type :supporting_document

    accepts_nested_attributes_for :expenses, reject_if: :all_blank, allow_destroy: true

    validates :question, presence: true
    validates :author, presence: true
    validates :content, presence: true

    def supporting_document_extension
        File.extname(supporting_document_file_name)[1..-1].downcase
    rescue
        ''
    end

    # Base value + total of income items - total of expense items
    def total_value
        return 0 if self.value.nil?
        self.value + self.expenses.includes(:expense).map{ |e|
            (e.quantity || 0) * (e.expense.signed_price || 0)
        }.sum
    end

    settings do
      mappings dynamic: false do
        indexes :upvote_count, type: :integer
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
            question: { only: [:campaign_id] }},
          methods: [:total_votes]
        )
      )
    end
end
