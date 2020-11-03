require 'rails_helper'

RSpec.describe AnswerSerializer, type: :serializer do
  it 'returns all fields and associations' do
    answer = create(:answer)
    create_list(:like, 10, answer: answer)
    serializer = AnswerSerializer.new(answer, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:author]).to_not be nil
    expect(serializer.serializable_hash[:question]).to_not be nil
    expect(serializer.serializable_hash[:total_likes]).to eq 10
    expect(serializer.serializable_hash[:permissions]).to be nil
  end

  include_examples 'preloads serialized data', :answer
end
