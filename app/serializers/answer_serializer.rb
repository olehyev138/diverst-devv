class AnswerSerializer < ApplicationRecordSerializer
  attributes :author, :question, :total_likes

  def serialize_all_fields
    true
  end
end
