class QuestionSerializer < ApplicationRecordSerializer
  attributes :title, :description, :campaign, :conclusion, :solved_at
  has_many :answers
  def serialize_all_fields
    true
  end
end
