require 'rails_helper'

RSpec.describe GroupMessageSerializer, type: :serializer do
  it 'returns associations' do
    group_message = create(:group_message)
    create(:group_message_comment, message: group_message)
    serializer = GroupMessageSerializer.new(group_message, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:group]).to be_nil
    expect(serializer.serializable_hash[:group_id]).to_not be_nil
    expect(serializer.serializable_hash[:owner]).to_not be_nil
    expect(serializer.serializable_hash[:comments_count]).to eq 1
  end
end
