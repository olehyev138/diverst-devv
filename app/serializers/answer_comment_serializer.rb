class AnswerCommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :author_id, :answer_id, :created_at, :updated_at, :approved
end
