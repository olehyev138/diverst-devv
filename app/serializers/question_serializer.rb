class QuestionSerializer < ApplicationRecordSerializer
  attributes  :answers, :title, :description, :campaign

  def serialize_all_fields
    true
  end
end
