require 'rails_helper'

RSpec.describe InitiativeCommentSerializer, type: :serializer do
  it 'returns associations' do
    initiative_comment = create(:initiative_comment)

    serializer = InitiativeCommentSerializer.new(initiative_comment, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(initiative_comment.id)
    expect(serializer.serializable_hash[:user]).to_not be nil
    expect(serializer.serializable_hash[:initiative]).to be nil
    expect(serializer.serializable_hash[:initiative_id]).to_not be nil
  end
end
