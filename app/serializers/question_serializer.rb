class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :campaign_id, :created_at, :updated_at, :solved_at, :conclusion
end
