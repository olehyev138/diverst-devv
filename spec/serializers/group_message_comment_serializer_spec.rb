require 'rails_helper'

RSpec.describe GroupMessageCommentSerializer, type: :serializer do
  it 'returns associations' do
    group_message_comment = create(:group_message_comment)

    serializer = GroupMessageCommentSerializer.new(group_message_comment, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:id]).to eq(group_message_comment.id)
    expect(serializer.serializable_hash[:author_id]).to eq(group_message_comment.author_id)
    expect(serializer.serializable_hash[:message_id]).to eq(group_message_comment.message_id)
    expect(serializer.serializable_hash[:permissions]).to_not be nil
  end
end
