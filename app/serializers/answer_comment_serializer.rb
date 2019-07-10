class AnswerCommentSerializer < ApplicationRecordSerializer
  attributes :author, :answer

  def serialize_all_fields
    true
  end
end
