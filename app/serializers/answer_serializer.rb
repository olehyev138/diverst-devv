class AnswerSerializer < ApplicationRecordSerializer
  attributes :question, :content, :total_likes

  belongs_to :author
  has_many :comments

  def serialize_all_fields
    true
  end
end
