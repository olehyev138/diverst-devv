class QuestionSerializer < ApplicationRecordSerializer
  attributes :title, :description, :conclusion, :solved_at, :permissions

  attributes_with_permission :campaign, :answers, if: :show_action?

  def answers
    object.answers.map do |ans|
      AnswerSerializer.new(ans, **instance_options)
    end
  end

  def serialize_all_fields
    true
  end
end
