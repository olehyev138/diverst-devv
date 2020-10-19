class AnswerSerializer < ApplicationRecordSerializer
  attributes :author
  attributes_with_permission :question, :total_likes,
                             :comments, if: :show_action?

  def comments
    object.comments.map do |comment|
      AnswerCommentSerializer.new(comment, **instance_options).as_json
    end
  end

  def serialize_all_fields
    true
  end
end
