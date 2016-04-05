class Answer < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :question, inverse_of: :answers
  belongs_to :author, class_name: 'User', inverse_of: :answers

  has_many :votes, class_name: 'AnswerUpvote'
  has_many :voters, through: :votes, class_name: 'User', source: :user
  has_many :comments, class_name: 'AnswerComment'

  has_attached_file :supporting_document, s3_permissions: :private
  do_not_validate_attachment_file_type :supporting_document

  def supporting_document_extension
    File.extname(file_file_name)[1..-1].downcase
  rescue
    ''
  end
end
