require 'rails_helper'

RSpec.describe QuestionSerializer, type: :serializer do
  it 'returns questions' do
    question = create(:question)
    serializer = QuestionSerializer.new(question, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to eq(question.id)
    expect(serializer.serializable_hash[:title]).to eq(question.title)
    expect(serializer.serializable_hash[:description]).to eq(question.description)
  end
end
