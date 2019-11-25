class QuestionSerializer < ApplicationRecordSerializer
  attributes :answers, :title, :description, :campaign, :conclusion, :solved_at
  def serialize_all_fields
    true
  end
end
