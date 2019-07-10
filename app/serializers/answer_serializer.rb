class AnswerSerializer < ApplicationRecordSerializer
  attributes :author, :question

  def serialize_all_fields
    true
  end
end
