require 'rails_helper'

RSpec.describe AnswerSerializer, type: :serializer do
  it 'returns all fields and associations' do
    answer = create(:answer)
    serializer = AnswerSerializer.new(answer)

    expect(serializer.serializable_hash[:id]).to_not be nil
    expect(serializer.serializable_hash[:author]).to_not be nil
    expect(serializer.serializable_hash[:question]).to_not be nil
  end
end
