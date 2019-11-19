class QuestionSerializer < ApplicationRecordSerializer
  attributes  :questions, :answers

  def serialize_all_fields
    true
  end
end
