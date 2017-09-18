class Answer < ActiveRecord::Base
    belongs_to :campaign
    belongs_to :question, inverse_of: :answers
    belongs_to :author, class_name: 'User', inverse_of: :answers

    has_many :votes, class_name: 'AnswerUpvote'
    has_many :voters, through: :votes, class_name: 'User', source: :user
    has_many :comments, class_name: 'AnswerComment'
    has_many :expenses, class_name: "AnswerExpense"

    has_attached_file :supporting_document, s3_permissions: "private"
    do_not_validate_attachment_file_type :supporting_document

    accepts_nested_attributes_for :expenses, reject_if: :all_blank, allow_destroy: true

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
end
