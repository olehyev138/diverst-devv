require 'rails_helper'

RSpec.describe AnswerCommentSerializer, type: :serializer do
  let(:answer_comment) { create(:answer_comment) }
  let(:serializer) { AnswerCommentSerializer.new(answer_comment, scope: serializer_scopes(create(:user))) }

  it 'returns all fields and associations' do
    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:author]).to_not be nil
    expect(serializer.serializable_hash[:answer]).to be nil
    expect(serializer.serializable_hash[:permissions]).to be nil
  end
end
