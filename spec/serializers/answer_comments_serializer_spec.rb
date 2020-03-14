require 'rails_helper'

RSpec.describe AnswerCommentSerializer, type: :serializer do
  it 'returns all fields and associations' do
    answer_comment = create(:answer_comment)
    serializer = AnswerCommentSerializer.new(answer_comment, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:author]).to_not be nil
    expect(serializer.serializable_hash[:answer]).to_not be nil
  end
end
