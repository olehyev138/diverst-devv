require 'rails_helper'

RSpec.describe QuestionSerializer, type: :serializer do
  let(:question) { create(:question) }
  let(:serializer) { QuestionSerializer.new(question, scope: serializer_scopes(create(:user))) }

  include_examples 'permission container', :serializer

  it 'returns questions' do
    expect(serializer.serializable_hash[:id]).to eq(question.id)
    expect(serializer.serializable_hash[:title]).to eq(question.title)
    expect(serializer.serializable_hash[:description]).to eq(question.description)
  end
end
